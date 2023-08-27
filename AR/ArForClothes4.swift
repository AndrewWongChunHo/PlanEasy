//
//  ArForClothes4.swift
//  PlanEasy
//
//  Created by Croquettebb on 9/5/2023.
//

import SwiftUI
import RealityKit
import ARKit
import Combine
import PhotosUI

struct ArForClothes4: UIViewRepresentable {
    
    let characterOffset: SIMD3<Float> = [0, 0, 0] // 角色在身體錨點上的位移
    let characterAnchor = AnchorEntity() // 用於定位角色的錨點實體
    var arView: ARView = ARView(frame: .zero) // ARView 實例
    var characterEntity: Entity? // 用於存放角色實體的屬性
    
    func makeUIView(context: Context) -> ARView {
        arView.session.delegate = context.coordinator // 設定 ARSession 的代理為 Coordinator
        print("success")
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if ARBodyTrackingConfiguration.isSupported { // 檢查是否支援 ARBodyTrackingConfiguration
            let configuration = ARBodyTrackingConfiguration()
            uiView.session.run(configuration) // 開始執行 ARBodyTrackingConfiguration
            uiView.scene.addAnchor(characterAnchor) // 將角色錨點實體加入 ARView 的場景中
                var cancellable: AnyCancellable? = nil
                cancellable = Entity.loadBodyTrackedAsync(named: "character/t_shirt").sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            print("錯誤：無法載入模型：\(error.localizedDescription)")
                        }
                        cancellable?.cancel()
                    }, receiveValue: { (character: Entity) in
                        if let character = character as? BodyTrackedEntity {
                            character.scale = [0.01, 0.01, 0.01]
                            self.arView.scene.addAnchor(characterAnchor)
                            self.characterAnchor.addChild(character)
                            cancellable?.cancel()
                        } else {
                            print("錯誤：無法載入模型為 BodyTrackedEntity")
                        }
                    })
        } else {
            fatalError("此功能僅支援 A12 芯片的設備")
        }
    }


    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        let parent: ArForClothes4
        
        init(_ parent: ArForClothes4) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
                
                let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
                parent.characterAnchor.position = bodyPosition + parent.characterOffset
                parent.characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
                
                if let character = parent.characterEntity, character.parent == nil {
                    parent.characterAnchor.addChild(character)
                }
            }
        }
    }
}

struct ArForClothes4View_Previews: PreviewProvider {
    static var previews: some View {
            MainPage()
    }
}
