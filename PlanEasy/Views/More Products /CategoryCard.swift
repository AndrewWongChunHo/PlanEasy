//
//  CategoryCard.swift
//  PlanEasy
//
//  Created by Croquettebb on 17/4/2023.
//

import SwiftUI

struct CategoryCard: View {
    
    var style: ClothingStyle
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                Image(style.image)
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 180)
                    .scaledToFit()
                
                VStack(alignment: .leading) {
                    Text(style.name)
                        .bold()
                    
                }
                .padding()
                .frame(width: 180, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
            .frame(width: 180, height: 250)
            .shadow(radius: 3)
    
            }
        }
    }

struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCard(style: styleList[0])
    }
}
