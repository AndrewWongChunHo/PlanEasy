//
//  FormViewModel.swift
//  PlanEasy
//
//  Created by Croquettebb on 9/2/2023.
//

import UIKit

class FormViewModel: ObservableObject {
    @Published var name = ""
    @Published var uiImage: UIImage
    
    var id: String?
    
    var updating: Bool { id != nil }
    
    init(_ uiImage: UIImage) {
        self.uiImage = uiImage
    }
    
    init(_ myImage: MyWardrobe) {
        name = myImage.nameView
        id = myImage.imageID
        uiImage = UIImage(systemName: "photo")!
    }
    
    var incomplete: Bool {
        name.isEmpty || uiImage == UIImage(systemName: "photo")!
    }
}
