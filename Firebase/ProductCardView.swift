//
//  ProductCardView.swift
//  PlanEasy
//
//  Created by Croquettebb on 19/4/2023.
//

import SwiftUI

struct ProductCardView: View {
    
    @State var image: String
    @State var title: String
    @State var subtitle: String
    @State var price: Double?
    
    var body: some View {
        VStack(spacing: 10){
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
                .frame(width: getRect().width / 2.5, height: getRect().width / 2.5)
            // Moving image to top to look like its fixed at half top
                .offset(y: -50)
                .padding(.bottom,-65)
            
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .padding(.top)
                .padding(.horizontal)
                .foregroundColor(.black)
            
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text("HKD $\(String(format: "%.2f", price ?? 0.0))")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color("bottom"))
                .padding(.top,5)
        }
        .frame(maxHeight: 200)
        .padding(.bottom,22)
        .background(
            Color.white
                .cornerRadius(25)
                .shadow(color: .gray, radius: 1)
        )
        .padding(.top,80)
    }
}

struct ProductCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCardView(image: "c1", title: "T-shirt", subtitle: "Navy")
    }
}


func getRect()->CGRect{
    return UIScreen.main.bounds
}
