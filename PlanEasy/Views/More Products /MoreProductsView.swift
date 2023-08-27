//
//  MoreProductsView.swift
//  PlanEasy
//
//  Created by SunnyHa on 29/3/2023.
//

import SwiftUI

struct MoreProductsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var sharedData: SharedDataModel
    
    @StateObject var homeData: HomeViewModel = HomeViewModel()
    
    var columns = [GridItem(.adaptive(minimum: 150), spacing: 20)]
    
    var body: some View {
        
        
        NavigationView{
            
            VStack (spacing: 0){

                HStack {
                    Text("Shop your favourites")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity,alignment: .leading)

                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut){
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Circle().foregroundColor(.white))
                            .shadow(color: Color.black.opacity(0.2), radius: 5)
                    }

                }
                .padding()
                
                ScrollView {
                    VStack{
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(styleList) { style in
                                NavigationLink(destination: getDestinationView(for: style).navigationBarBackButtonHidden(true)) {
                                    CategoryCard(style: style)
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                }
                .padding(.bottom, -400)
               }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
            .background(Color("HomeBG").ignoresSafeArea())
        }
        

    }
    


struct MoreProductsView_Previews: PreviewProvider {
    static var previews: some View {
        MoreProductsView()
    }
}


func getDestinationView(for style: ClothingStyle) -> some View {
    switch style.name {
    case "Japanese Style":
        return AnyView(JapaneseView())
    case "Street Style":
        return AnyView(StreetView())
    case "Vintage Style":
        return AnyView(VintageView())
    case "City Boy Style":
        return AnyView(CityBoyView())
    case "Formal Style":
        return AnyView(FormalView())
    case "Korean Style":
        return AnyView(KoreanView())
    default:
        return AnyView(EmptyView())
    }
}
