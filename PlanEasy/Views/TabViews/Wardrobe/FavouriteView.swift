//
//  FavouriteView.swift
//  PlanEasy
//
//  Created by Croquettebb on 24/4/2023.
//

import SwiftUI

struct FavouriteView: View {
    
    @ObservedObject var favouriteViewModel = FavouriteViewModel()
    
    init(favouriteViewModel: FavouriteViewModel) {
        self.favouriteViewModel = favouriteViewModel
        self.favouriteViewModel.fetchFavouriteItems()
    }
    
    var body: some View {
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    
                    HStack{
                        
                        Text("Your Wardrobe")
                            .font(.system(size: 28).bold())
                        
                        Spacer()
                        
                    }
                    
                    // Checking if liked products are empty
                    if favouriteViewModel.favouriteItems.isEmpty{
                        
                        Group{
                            Image("empty_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                                .padding(.leading,30)
                                .padding(.top,35)
                                .frame(maxWidth: 300)
                            
                            Text("No favorites yet")
                                .font(.system(size: 25))
                                .fontWeight(.semibold)
                            
                            Text("Go view the main page to see what you are favorites")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.top,10)
                                .multilineTextAlignment(.center)
                        }
                    }
                    else{
                        
                        // Displaying Products
                        VStack(spacing: 15) {
                            ForEach(self.favouriteViewModel.favouriteItems, id: \.title) { item in
                                FavouriteCardView(title: item.title, subtitle: item.subtitle, price: item.price, image: item.productImage, id: item.itemID)
                            }
                        }
                        .onAppear {
                            favouriteViewModel.fetchFavouriteItems()
                        }
                        .padding(.top,25)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                
                Color("HomeBG")
                    .ignoresSafeArea()
            )
        }
    }
    
    struct FavouriteView_Previews: PreviewProvider {
        static var previews: some View {
            FavouriteView(favouriteViewModel: FavouriteViewModel())
        }
    }
    
    struct FavouriteCardView: View {
        
        @State var title: String
        @State var subtitle: String
        @State var price: Double
        @State var image: String
        @ObservedObject var favouriteViewModel = FavouriteViewModel()
        var id: String
        
        var body: some View {
            
            HStack(spacing: 15){
                
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        Text(title)
                            .font(.system(size: 18).bold())
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Button(action: {
                            favouriteViewModel.removeFavItem(itemID: id)
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        })
                        .padding(.trailing, 10)
                    }
                    
                    Text(subtitle)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("bottom"))
                    
                    Text("HKD \(Int(price))")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal,10)
            .padding(.vertical,10)
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(
                
                Color.white
                    .cornerRadius(10)
            )
        }
    }
    
}
