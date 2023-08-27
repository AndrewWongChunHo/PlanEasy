//
//  TryOnCard.swift
//  PlanEasy
//
//  Created by Croquettebb on 9/5/2023.
//

import SwiftUI

struct TryOnCard: View {
    
    var image: String
    var name: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                Image(image)
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 180)
                    .scaledToFit()
                
                VStack(alignment: .leading) {
                    Text(name)
                        .bold()
                    
                }
                .padding()
                .frame(width: 180, alignment: .leading)
                .background(Color("bottom"))
                .foregroundColor(.white)
                .cornerRadius(20)
            }
            .frame(width: 180, height: 250)
            .shadow(radius: 3)
    
            }
        }
}

struct TryOnCard_Previews: PreviewProvider {
    static var previews: some View {
        TryOnCard(image: "p1", name: "Clothes 1")
    }
}
