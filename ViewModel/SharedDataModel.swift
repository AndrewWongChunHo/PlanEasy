//
//  SharedDataModel.swift
//  PlanEasy
//
//  Created by SunnyHa on 2/4/2023.
//

import SwiftUI

class SharedDataModel: ObservableObject {
    
    @Published var paymentSuccess = false
    
    @Published private(set) var products: [Product] = []
    
    // Detail Product Data
    @Published var detailProduct: Product?
    @Published var showDetailProduct: Bool = false
    
    // Matched Geoemtry Effect from Search page
    @Published var fromSearchPage: Bool = false
    
    // Liked Products add to Wardrobe
    @Published var likedProducts: [Product] = []
    
    // Basket Products
    @Published var cartProducts: [Product] = []
    
    func getTotalPrice() -> Double {
        var total: Double = 0.0

        cartProducts.forEach { product in
            let price = product.price

            if let priceDouble = price {
                let quantity = Double(product.quantity)
                let priceTotal = quantity * priceDouble
                total += priceTotal
            }
        }

        return total
    }


}

