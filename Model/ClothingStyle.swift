//
//  ClothingStyle.swift
//  PlanEasy
//
//  Created by Croquettebb on 17/4/2023.
//

import Foundation


struct ClothingStyle: Identifiable {
    var id = UUID()
    var name: String
    var image: String
}

var styleList = [ClothingStyle(name: "Japanese Style", image: "Japanese"),
                 ClothingStyle(name: "Street Style", image: "streetStyle"),
                 ClothingStyle(name: "Vintage Style", image: "vintageStyle"),
                 ClothingStyle(name: "Korean Style", image: "koreanStyle"),
                 ClothingStyle(name: "City Boy Style", image: "cityBoy"),
                 ClothingStyle(name: "Formal Style", image: "Formal"),
]
