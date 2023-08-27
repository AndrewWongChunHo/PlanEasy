//
//  HomeViewVM.swift
//  PlanEasy
//
//  Created by Croquettebb on 16/4/2023.
//

import Foundation
import SwiftUI

extension WeatherKitView {
    @MainActor class HomeViewVM: ObservableObject {
        @Published var weatherForecast = [(String, Image, Double, Image)]()
        private var networkService = NetworkService()
        
        private var date: String?
        private var image: Image?
        private var temperature: Double?
        private var background: Image?
        
        @Published var currentTemperature: Double?
        @Published var currentWeatherImage: Image?
        @Published var currentDate: String?
        @Published var currentWeatherBackground: Image?
        
        func fetchWeather(){
            networkService.performWeatherRequest { [self] forecast in
                for day in forecast {
                    DispatchQueue.main.async { [self] in
                        date = convertFromDate(date: day.date)
                        image = checkCode(code: String(day.weatherCode), temperature: day.temperature)
                        temperature = day.temperature
                        background = checkCodeForBackground(code: String(day.weatherCode))
                        if day == forecast.first! {
                            currentTemperature = temperature
                            currentWeatherImage = image
                            currentDate = date
                            currentWeatherBackground = background // set currentWeatherVideo based on the weather code
                        }
                        self.weatherForecast.append((date!, image!, temperature!, background!))
                    }
                }
            }
        }
       


        private func convertFromDate(date: Date) -> String{
            let dateString = date.description
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ"
            
            guard let date = formatter.date(from: dateString) else {
                return ""
            }
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: date)
            formatter.dateFormat = "MM"
            let monthNumber = formatter.string(from: date)
            var month: String
            if monthNumber == "08" {
                month = "JAN"
            } else {
                formatter.dateFormat = "MMMM"
                month = formatter.string(from: date)
            }
            formatter.dateFormat = "dd"
            let day = formatter.string(from: date)
            
            
            return "\(day) \(month) \(year)"
        }
        
        private func checkCode(code: String, temperature: Double) -> Image{
            switch code {
            case "1000", "1100":
                if temperature > 19 {
                    return Image("short.sunny")
                } else {
                    return Image("long.sunny")
                }
            case "1101", "1102", "1001":
                if temperature > 19 {
                    return Image("short.cloudy")
                } else {
                    return Image("long.cloudy")
                }
            case "4000", "4001", "4200":
                if temperature > 19 {
                    return Image("short.drizzle")
                } else {
                    return Image("long.drizzle")
                }
            case "4201":
                if temperature > 19 {
                    return Image("short.heavyRain")
                } else {
                    return Image("long.heavyRain")
                }
            case "8000":
                if temperature > 19 {
                    return Image("short.thunder")
                } else {
                    return Image("long.thunder")
                }
            default:
                return Image("short.sunny")
            }
        }
        
        private func checkCodeForBackground(code: String) -> Image{
            switch code {
            case "1000", "1100":
                return Image("sunny")
            case "1101", "1102", "1001":
                return Image("cloudy")
            case "4000", "4001", "4200":
                return Image("drizzle")
            case "4201":
                return Image("heavyRain")
            case "8000":
                return Image("thunder")
            default:
                return Image("sunny")
            }
        }
    }
}






