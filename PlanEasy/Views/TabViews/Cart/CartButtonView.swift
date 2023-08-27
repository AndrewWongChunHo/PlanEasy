//
//  CartButtonView.swift
//  PlanEasy
//
//  Created by Croquettebb on 20/4/2023.
//
 
import SwiftUI
 
struct CartButtonView: View {
    var numberOfItems: Int
 
    var body: some View {
        VStack {
            Image(systemName: "cart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(Color.black.opacity(0.7))
                .overlay(ImageOverlay(numberOfItems: numberOfItems), alignment: .center)
            Spacer()
        }
    }
 
    struct ImageOverlay: View {
        var numberOfItems: Int
 
        var body: some View {
            ZStack {
                Text(String(numberOfItems))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .offset(x:10, y:10)
            }
        }
    }
}
 
struct CartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CartButtonView(numberOfItems: 12)
    }
}
