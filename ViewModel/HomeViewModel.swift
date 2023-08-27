//
//  HomeViewModel.swift
//  PlanEasy
//
//  Created by SunnyHa on 28/3/2023.
//

import SwiftUI

// Using Combine to monitor search field and if user leaves for .5 secs then starts searching
import Combine

class HomeViewModel: ObservableObject {
    
    
    @Published var productType: ProductType = .Today
    
    // Sample Products
    @Published var products: [Product] = [
    
        Product(type: .Today, title: "Loose Fit T-Shirt", subtitle: "Short Blue", price: 79.00, productImage: "c1", model: "", style: "Japanese Style"),
        Product(type: .Today, title: "Ultra Light Down Jacket ", subtitle: "Olive", price: 599.00, productImage: "c4", model: "", style: "Japanese Style"),
        Product(type: .Interview, title: "男裝 彈性西裝外套", subtitle: "深灰色", price: 599.00, productImage: "c2", model: "", style: "Japanese Style"),
        Product(type: .Dating, title: "寬鬆條紋圓領T恤", subtitle: "短袖 藍色", price: 79.00, productImage: "c1", model: "", style: "Japanese Style"),
    ]
    
    // Filtered Product
    @Published var filteredProducts: [Product] = []
    
    // More products on the type
    @Published var showMoreProductsOnType: Bool = false
    
    // Search Data
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    @Published var searchProducts: [Product]?
    
    var searchCancellable: AnyCancellable?
    
    init() {
        filteredProductByType()
        
        searchCancellable = $searchText.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: {
                str in
                
                if str != ""{
                    self.filteredProductBySearch()
                }
                else{
                    self.searchProducts = nil
                }
            })
    }
    
    func filteredProductByType(){
        
        // Filtering Product By Product Type
        DispatchQueue.global(qos: .userInteractive).async {
            
            let results = self.products
            // It will require more memory so were lazy to perform more
                .lazy
                .filter { product in
                    
                    return product.type == self.productType
                }
            // Limiting result
                .prefix(4)
            
            DispatchQueue.main.async {
                
                self.filteredProducts = results.compactMap({ product in
                    return product
                })
            }
        }
    }
    
    func filteredProductBySearch(){
        
        // Filtering Product By Product Type
        DispatchQueue.global(qos: .userInteractive).async {
            
            let results = self.products
            // It will require more memory so were lazy to perform more
                .lazy
                .filter { product in
                    
                    return product.title.lowercased().contains(self.searchText.lowercased())
                }
            
            DispatchQueue.main.async {
                
                self.searchProducts = results.compactMap({ product in
                    return product
                })
            }
        }
    }
}

