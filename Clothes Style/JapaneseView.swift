//
//  JapaneseView.swift
//  PlanEasy
//
//  Created by Croquettebb on 19/4/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct JapaneseView: View {
    
    @ObservedObject var clothes = getClothes()
    @Environment(\.presentationMode) var presentationMode
    var columns = [GridItem(.adaptive(minimum: 150), spacing: 20)]
    
    var body: some View {
        NavigationView {
            ZStack {

                VStack{
                    
                    HStack{
                        Button{
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(Color.black.opacity(0.9))
                        }

                        
                        Spacer()
                    }
                    .padding()
                    .padding(.top, 10)
                    
                    HStack {
                        Text("Japanese Style")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                ForEach(self.clothes.datas.filter { $0.style == "Japanese Style" }) { i in
                                    NavigationLink(destination: ProductDetailView(clothes: i).navigationBarBackButtonHidden(true)) {
                                        ProductCardView(image: i.productImage, title: i.title, subtitle: i.subtitle, price: i.price)
                                            .frame(width: 100, height: 200)
                                            .padding(.bottom, 80)
                                    }
                                }
                                        }
                            .padding()
                                    }
                        }
                    .padding(.top, 10)
                }
             }
              .background(Color("HomeBG").ignoresSafeArea())
            }
      
        }
    }


struct JapaneseView_Previews: PreviewProvider {
    static var previews: some View {
        JapaneseView()
    }
}



