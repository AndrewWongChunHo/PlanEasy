//
//  MyWardrobe+extension.swift
//  PlanEasy
//
//  Created by Croquettebb on 9/2/2023.
//

import UIKit


extension MyWardrobe {
    var nameView: String {
        //If it is optional, it will return an empty string
        name ?? ""
    }
    
    var imageID: String {
        id ?? ""
    }
    
    var uiImage: UIImage {
        if !imageID.isEmpty,
           let image = FileManager().retrieveImage(with: imageID) {
            return image
        } else {
            return UIImage(systemName: "photo")!
        }
    }
}

