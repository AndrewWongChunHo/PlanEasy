//
//  HomeView.swift
//  PlanEasy
//
//  Created by Croquettebb on 12/2/2023.
//

import SwiftUI

struct MainPage: View {
    // Current Tab
    @State var currentTab: Tab = .Home
    
    @StateObject var sharedData: SharedDataModel = SharedDataModel()
    
    // Animation Namespace
    @Namespace var animation
    
    var clothesViewModel: getClothes = getClothes()
    
    // Hiding Tab Bar
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack(spacing: 0){
        
            // Tab View
            TabView(selection: $currentTab) {
                
                HomeView(clothesViewModel: clothesViewModel, animation: animation)
                    .environmentObject(sharedData)
                    .tag(Tab.Home)
                
                FavouriteView(favouriteViewModel: FavouriteViewModel())
                    .environmentObject(sharedData)
                    .tag(Tab.Wardrobe)
                
                PhotoEditView()
                    .tag(Tab.PhotoEdit)
                
                ShoppingCartView(cartViewModel: CartViewModel())
                    .environmentObject(sharedData)
                    .tag(Tab.Cart)
                
                Profile()
                    .tag(Tab.Profile)
            }
            
            // Custom Tab Bar
            HStack(spacing: 0){
                ForEach(Tab.allCases,id: \.self){tab in
                    
                    Button {
                        // updating tab
                        currentTab = tab
                    } label: {
                        Image(tab.rawValue)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                        // Applying little shadow at bg
                            .background(
                                
                                Color("bottom")
                                    .opacity(0.1)
                                    .cornerRadius(5)
                                // blurring
                                    .blur(radius: 5)
                                // Making little big
                                    .padding(-7)
                                    .opacity(currentTab == tab ?
                                             1 : 0)
                            )
                            .frame(maxWidth: .infinity)
                            .foregroundColor(currentTab == tab ? Color("bottom") :
                                Color.black.opacity(0.3))
                    }
                }
            }
            .padding([.horizontal,.top])
            .padding(.bottom,10)
        }
        .background(Color("HomeBG").ignoresSafeArea())
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainControlView(imageSize: 250)

    }
}

// Making Case iteratable
// Tab Cases
enum Tab: String,CaseIterable{
    
    // Raw Value must be image Name in asset
    case Home = "Home"
    case Wardrobe = "Wardrobe"
    case PhotoEdit = "PhotoEdit"
    case Cart = "Cart"
    case Profile = "Profile"
    
}
