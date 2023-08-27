//
//  SearchView.swift
//  PlanEasy
//
//  Created by SunnyHa on 29/3/2023.
//

import SwiftUI

struct SearchView: View {
    var animation: Namespace.ID
    
    // Shared Data
    @EnvironmentObject var sharedData: SharedDataModel
    
    @EnvironmentObject var homeData: HomeViewModel
    
    // Activating Text Field with the help of FocusState
    @FocusState var startTF: Bool
    
    var body: some View {
        
        VStack(spacing: 0){
            
            // Search Bar
            HStack(spacing: 20){
                
                // Close Button
                Button {
                    withAnimation {
                        homeData.searchActivated = false
                    }
                    homeData.searchText = ""
                    // Resetting
                    sharedData.fromSearchPage = false
                } label: {
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
                    TextField("Search", text: $homeData.searchText)
                        .focused($startTF)
                        .disableAutocorrection(true)
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(
                
                    Capsule()
                        .strokeBorder(Color("bottom"),lineWidth: 1.5)
                )
                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                .padding(.trailing,20)
            }
            .padding([.horizontal])
            .padding(.top)
            .padding(.bottom,10)
            
            // Showing Progress if searching
            if let products = homeData.searchProducts{
                
                if products.isEmpty{
                    
                    // No Results Found
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
                }
                else{
                    // Filter Results
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 0){
                            
                            // Found Text
                            Text("Found \(products.count) reuslts")
                                .font(.system(size: 24).bold())
                                .padding(.vertical)
                            
                            // Staggered Grid
                            StaggeredGrid(columns: 2,spacing: 20, list: products) {
                                Product in
                                
                                // Card View
                                ProductCardView(product: Product)
                            }
                        }
                        .padding()
                    }
                }
            }
            else{
                
                ProgressView()
                    .padding(.top,30)
                    .opacity(homeData.searchText == "" ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .background(
        
            Color("HomeBG")
                .ignoresSafeArea()
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startTF = true
            }
        }
    }
    
    @ViewBuilder
    func ProductCardView(product: Product)->some View{
        
        VStack(spacing: 10){
            
            ZStack{
                
                if sharedData.showDetailProduct{
                    Image(product.productImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0)
                }
                else{
                    Image(product.productImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: "\(product.id)SEARCH", in: animation)
                }
            }
            // Moving image to top to look like its fixed at half top
            .offset(y: -50)
            .padding(.bottom,-65)
            
            Text(product.title)
                .font(.system(size: 18, weight: .semibold))
                .padding(.top)
            
            Text(product.subtitle)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text(String(format: "%.2f", product.price ?? 0.0))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color("bottom"))
                .padding(.top,5)
        }
        .padding(.horizontal,20)
        .padding(.bottom,22)
        .background(
        
            Color.white
                .cornerRadius(25)
                .shadow(color: .gray, radius: 1)
        )
        .padding(.top,40)
        .onTapGesture {
            
            withAnimation(.easeInOut){
                sharedData.fromSearchPage = true
                sharedData.detailProduct = product
                sharedData.showDetailProduct = true
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
