//
//  Product.swift
//  PlanEasy
//
//  Created by SunnyHa on 28/3/2023.
//

import SwiftUI

// Product Model
struct Product: Identifiable,Hashable {
    var id = UUID().uuidString
    var type: ProductType = .Today
    var title: String
    var subtitle: String
    var price: Double?
    var productImage: String
    var quantity: Int = 1
    var model: String
    var style: String
}


