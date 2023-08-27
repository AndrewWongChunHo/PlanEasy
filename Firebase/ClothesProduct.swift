//
//  ClothesProduct.swift
//  PlanEasy
//
//  Created by Croquettebb on 19/4/2023.
//

import Foundation
import FirebaseFirestoreSwift
import Combine

struct ClothesProduct: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var title: String
    var subtitle: String
    var price: Double?
    var productImage: String
    var style: String = ""
    var model: String = ""
    var quantity: Int = 1
    var isFavourite: Bool = false
    var sceneKit: String = ""
    var type: String = ""
    
    init(id: String, title: String, subtitle: String, price: Double?, productImage: String, style: String, model: String, sceneKit: String, type: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.style = style
        self.model = model
        self.productImage = productImage
        self.sceneKit = sceneKit
        self.type = type
        self.isFavourite = UserDefaults.standard.bool(forKey: id ?? "") // Retrieve the state of isFavourite from UserDefaults
    }
}

