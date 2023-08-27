//
//  HomeView.swift
//  PlanEasy
//
//  Created by Croquettebb on 1/5/2023.
//

import SwiftUI

let custommFont = "Pacifico-Regular"

struct HomeView: View {
    //Clothes Card
    @State var data : CardStackData = CardStackData()
    @State var degree = 0.0
    @State var weatherOffset = -200.0
    @State var cardOffset = -80.0
    @State private var isShowingWeatherKitView = false
    let durationAndDelay : CGFloat = 0.3
    @ObservedObject var clothesViewModel: getClothes
    
    var animation: Namespace.ID
    
    // Share Data
    @EnvironmentObject var sharedData: SharedDataModel
    
    @StateObject var homeData: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15){
                    
                    VStack(spacing: 0){
                        
                        HStack{
                            
                            Button(action: {
                                isShowingWeatherKitView = true
                            }) {
                                Image(systemName: "cloud.fill")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .sheet(isPresented: $isShowingWeatherKitView) {
                                WeatherKitView()
                            }
                            
                            Spacer()
                            
                            if homeData.searchActivated{
                                SearchBar()
                            }
                            else{
                                SearchBar()
                                    .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                            }
                            
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal,25)
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            homeData.searchActivated = true
                        }
                    }
                    
                    VStack {
                        Text("Random Box")
                            .font(.custom(custommFont, size: 30).bold())
                            .frame(maxWidth: .infinity,alignment: .center)
                    }
                    
                    
                    // Clothes Card
                    ZStack {
                        LinearGradient(gradient: .init(colors: [Color("top"),Color("bottom")]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1)).opacity(0.01)
                        HStack {
                            VStack {
                                WeatherWidget().padding(.top, 10).padding(.leading, 10)
                            }.offset(x:weatherOffset)
                            VStack {
                                CardStack(degree: $degree).environmentObject(data).frame(height: 400)
                                Spacer()
                            }.offset(x:cardOffset)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.width < 0{
                                // left
                                withAnimation(.linear(duration: durationAndDelay)) {
                                    if (degree == 0 && cardOffset != -80){
                                        degree = 25
                                        
                                    }else{
                                        degree = 0
                                    }
                                    weatherOffset = -200.0
                                    cardOffset = -80
                                }
                            }
                            
                            if value.translation.width > 0 {
                                // right
                                withAnimation(.linear(duration: durationAndDelay)) {
                                    if (degree == 0){
                                        degree = -25
                                    }
                                    weatherOffset = 0
                                    cardOffset = 50
                                }
                            }
                            if value.translation.height < 0 {
                                // up
                            }
                            
                            if value.translation.height > 0 {
                                // down
                            }
                        })
                    )
                    .animation(.spring())
                    
                    // Products Tab
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 18){
                            
                            ForEach(ProductType.allCases,id: \.self){
                                type in
                                // Product Type View
                                ProductTypeView(clothesViewModel: clothesViewModel, type: type)
                            }
                        }
                        .padding(.horizontal,25)
                    }
                    .padding(.top,28)
                    
                    // Products Page
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 25){
                            
                            ForEach(clothesViewModel.datas.filter({ $0.type == clothesViewModel.selectedType })) { i in
                                NavigationLink(destination: ProductDetailView(clothes: i).navigationBarBackButtonHidden(true)) {
                                    ProductCardView(image: i.productImage, title: i.title, subtitle: i.subtitle, price: i.price)
                                        .frame(width: 100, height: 350)
                                        .padding()
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.horizontal,25)
                        .padding(.bottom)
                        .padding(.top,-60)
                    }
                    
                    
                    Button {
                        homeData.showMoreProductsOnType.toggle()
                    } label: {
                        
                        Label {
                            Image(systemName: "arrow.right")
                        } icon: {
                            Text("Explore your style")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color("bottom"))
                    }
                    .padding(.top, -40)
                    .frame(maxWidth: .infinity,alignment: .trailing)
                    .padding(.trailing)
                    
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color("HomeBG"))
            // Updating data whenever tab changes
            .onChange(of: homeData.productType) { newValue in
                homeData.filteredProductByType()
            }
            // Preview Issue
            .fullScreenCover(isPresented: $homeData.showMoreProductsOnType) {
                MoreProductsView()
            }

            // Displaying Search View
            .overlay(
                
                ZStack{
                    
                    if homeData.searchActivated{
                        SearchProductsView()
                    }
                }
            )
        }
    }
    
    @ViewBuilder
    func SearchBar()->some View{
        
        VStack {
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(.black)
                .padding(10)
                .background(Circle().foregroundColor(.white))
                .shadow(color: Color.black.opacity(0.2), radius: 5)
        }
        
    }
    

}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}

struct ProductTypeView: View {
    
    @StateObject var clothesViewModel = getClothes()
    
    var type: ProductType
    
    var body: some View{
        VStack{
            Button(action: {
                // Updating Current Type
                withAnimation {
                    clothesViewModel.selectedType = type.rawValue
                }
            }) {
                Text(type.rawValue)
                    .fontWeight(.semibold)
                    // Changing Color based on Current product Type
                    .foregroundColor(clothesViewModel.selectedType == type.rawValue ? Color("bottom") : Color.gray)
                    .padding(.bottom,10)
                    // Adding Indicator at bottom
                    .overlay(
                        
                        // Adding Matched Geometry Effect
                        ZStack{
                            if clothesViewModel.selectedType == type.rawValue {
                                Capsule()
                                    .fill(Color("bottom"))
                                    .matchedGeometryEffect(id: "PRODUCTTAB", in: Namespace().wrappedValue)
                                    .frame(height: 2)
                            } else {
                                Capsule()
                                    .fill(Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        .padding(.horizontal,-5)
                        ,alignment: .bottom
                    )
            }
        }
    }
}

