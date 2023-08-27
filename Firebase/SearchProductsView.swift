//
//  SearchProductsView.swift
//  PlanEasy
//
//  Created by Croquettebb on 23/4/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine

struct SearchProductsView: View {
    @State private var isShowingMainPage = false
    @State var searchText = ""
    @ObservedObject var clothes = getClothes()
    
    var body: some View {
        ZStack{
            VStack {
                SearchBarView(text: $searchText)
                ScrollView(.vertical, showsIndicators: false) {
                    if clothes.datas.filter({ searchText.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(searchText) }).isEmpty {
                        // Show "Item Not Found" view if the filtered array is empty
                        VStack(spacing: 10){
                            Image("NotFound")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.top,40)

                            Text("Item Not Found")
                                .font(.system(size: 22).bold())
                                .padding(.top,25)

                            Text("Try a more generic search term or try looking for alternative products.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal,30)
                        }
                        .padding()
                    } else {
                        // Show the list of products if the filtered array is not empty
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                            ForEach(self.clothes.datas.filter { searchText.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(searchText) }) { i in
                                NavigationLink(destination: ProductDetailView(clothes: i).navigationBarBackButtonHidden(true)) {
                                    ProductCardView(image: i.productImage, title: i.title, subtitle: i.subtitle, price: i.price)
                                        .frame(width: 100, height: 200)
                                        .padding(.bottom, 90)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding(.top, 10)
                }

        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .background(
            Color("HomeBG")
                .ignoresSafeArea()
        )
    }
}

struct SearchProductsView_Previews: PreviewProvider {
    static var previews: some View {
                SearchProductsView()
    }
}

struct SearchBarView: View {
    @Binding var text: String
    @State private var isShowingMainPage = false
    var body: some View {
        HStack(spacing: 20){
            
            // Close Button
            Button(action: {
                withAnimation(.easeInOut) {
                    self.isShowingMainPage.toggle()
                }
            }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(Color.black.opacity(0.7))
            }
            
            // Search Bar
            HStack(spacing: 15){
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                // Since we need a separate view for search bar
                TextField("Search", text: $text)
                    .disableAutocorrection(true)
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(.systemGray2))
                        }
                    }
            }
            .padding(.vertical,12)
            .padding(.horizontal)
            .background(
            
                Capsule()
                    .strokeBorder(Color("bottom"),lineWidth: 1.5)
            )
            .padding(.trailing,20)
        }
        .padding([.horizontal])
        .padding(.top)
        .padding(.bottom,10)
        .fullScreenCover(isPresented: $isShowingMainPage, content: {
            MainPage().transition(.move(edge: .trailing))
                })
    }
}

