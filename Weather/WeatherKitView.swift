//
//  WeatherKitView.swift
//  PlanEasy
//
//  Created by Croquettebb on 14/4/2023.
//

import SwiftUI
import WeatherKit
import CoreLocation


struct WeatherKitView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = HomeViewVM()
   
    
    var body: some View {
         ZStack {
             viewModel.currentWeatherBackground?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
             
             VStack {
                 
                 VStack(spacing:4) {
                     Text("Today's Weather")
                         .font(.largeTitle)
                         .fontWeight(.bold)
                         .foregroundColor(.white)
                     Text(viewModel.currentDate ?? "12 MAY 2023")
                         .font(.headline)
                         .foregroundColor(.white)
                 }
                 .padding(.top, -10)
                 
                 Spacer()
                 
                 HStack(spacing: 20){
                     viewModel.currentWeatherImage?
                         .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 103, height: 103)
                             .clipped()
                         .frame(width: 103, height: 103)
                     
                     VStack{
                         Text("\(String(viewModel.currentTemperature ?? 0.0))°").font(.custom("Nunito Sans Bold", size: 60)).foregroundColor(Color(#colorLiteral(red: 0.96, green: 0.96, blue: 0.96, alpha: 1))).multilineTextAlignment(.center)
                         
                         if viewModel.currentTemperature ?? 0.0 > 19 {
                             Text("It’s Short Sleeve Day").font(.custom("Nunito Sans Black", size: 18)).foregroundColor(Color(#colorLiteral(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)))
                                 .fontWeight(.bold)
                         } else {
                             Text("It’s Long Sleeve Day").font(.custom("Nunito Sans Black", size: 18)).foregroundColor(Color(#colorLiteral(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)))
                         }
                         
                     }
                 }
                 .padding(.top, 35)
                 .padding(.leading, -15)
                 
                 ScrollView(.vertical) {
                     VStack{
                         if !viewModel.weatherForecast.isEmpty {
                             ForEach(viewModel.weatherForecast, id: \.0) { forecast in
                                 WeatherDisplayView(date: forecast.0, image: forecast.1, temperature: forecast.2)
                                     .frame(height: 100)
                             }
                         }
                         }
                        .frame(width: 400, height: 500)
                 }
                 .frame(width: 300, height: 380)
                 .padding(.top, 120)
             }
             .padding(.top, 10)
             .frame(width: 300, height: 300)
             .onAppear {
                 viewModel.fetchWeather()
             }
             .frame(maxWidth: .infinity, maxHeight: .infinity)
             
        }
             
    }
}

struct WeatherKitView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherKitView()
    }
}

struct WeatherDisplayView: View {
    
    var date: String
    var image: Image
    var temperature: Double
    
    var body: some View {
        
        VStack(spacing: 15) {
            HStack(spacing: 55){
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                    .clipped()
                    .frame(width: 75, height: 75)
                
                VStack{
                    Text(String("\(temperature)°")).font(.custom("Nunito Sans Bold", size: 47)).foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))).multilineTextAlignment(.center)
                    
                    Text(date).font(.custom("Nunito Sans Black", size: 13)).foregroundColor(Color(#colorLiteral(red: 0.87, green: 0.86, blue: 0.95, alpha: 1)))
                }
            }
            .padding(.leading, -5)
            
            Divider()
                .frame(width: 280)
            
        }
        
    }
        
    }

