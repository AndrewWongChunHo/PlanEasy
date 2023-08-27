//
//  ClothesViewModel.swift
//  PlanEasy
//
//  Created by Croquettebb on 19/4/2023.
//

import Foundation
import Combine
import Firebase

class getClothes: ObservableObject {
    @Published var datas = [ClothesProduct]()
    @Published var selectedType: String = ProductType.Today.rawValue
    
    init() {
        let db = Firestore.firestore()
        
        db.collection("item").addSnapshotListener { (snap, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges {
                let id = i.document.documentID
                let title = i.document.get("title") as! String
                let subtitle = i.document.get("subtitle") as! String
                let price = i.document.get("price") as! Double
                let productImage = i.document.get("productImage") as! String
                let style = i.document.get("style") as! String
                let model = i.document.get("model") as! String
                let sceneKit = i.document.get("sceneKit") as! String
                let type = i.document.get("type") as! String
                
                self.datas.append(ClothesProduct(id: id, title: title, subtitle: subtitle, price: price, productImage: productImage, style: style, model: model, sceneKit: sceneKit, type: type))
            }
            
        }
    }
    
}

// Product Types
enum ProductType: String,CaseIterable{
    case Today = "Today's Wearable"
    case Interview = "Interview"
    case Dating = "Dating"
    case Hiking = "Hiking"
    case Sport = "Sport"
}
