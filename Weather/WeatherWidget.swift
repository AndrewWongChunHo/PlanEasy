//
//  WeatherWidget.swift
//  PlanEasy
//
//  Created by Jack Tsoi on 21/2/2023.
//

import SwiftUI


struct WeatherWidget: View {
    
    @ObservedObject var weatherData = WeatherData()
    
    var body: some View {
        VStack(alignment: .center) {
            Text("\(String(format:"%.1f",weatherData.temperature))°")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(weatherData.description)
                .font(.title2)
                .foregroundColor(.white)
            HStack {
                Image(systemName: weatherData.iconName)
                    .foregroundColor(.white)
                Text("\(String(format:"%.1f",weatherData.highTemperature))° / \(String(format:"%.1f",weatherData.lowTemperature))°")
                    .foregroundColor(.white)
            }
            .padding(.top)
        }
        .frame(width: 125, height: 125)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        
    }
}


class WeatherData: ObservableObject {
    
    @Published var temperature: Double = 0.0
    @Published var highTemperature: Double = 0
    @Published var lowTemperature: Double = 0
    @Published var description: String = ""
    @Published var iconName: String = ""
    @Published var humidity: Double = 0.0
    @Published var cityName: String = ""
    
    init() {
        fetchWeather()
    }
    
    func fetchWeatherData() {
        // This is where you would make an API request to fetch the weather data
        // For the purpose of this example, we will hard-code the values
        temperature = 23
        highTemperature = 28
        lowTemperature = 20
        description = "Sunny"
        iconName = "sun.max.fill"
    }
    func fetchWeather() {
        let apiKey = "48b57f6ede0c368dc27a2989771c3ea5"
        let city = "HongKong"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        
        guard let url = URL(string: urlString) else { return }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            
            do {
                let weatherDatas = try JSONDecoder().decode(WeatherDatas.self, from: data)
                DispatchQueue.main.async {
                    self.temperature = weatherDatas.main.temp
                    self.highTemperature = weatherDatas.main.temp_max
                    self.lowTemperature = weatherDatas.main.temp_min
                    self.humidity = weatherDatas.main.humidity
                    self.cityName = weatherDatas.name
                    self.iconName = "cloud.fill"
                    self.description = weatherDatas.name
                }
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    
    struct WeatherView_Previews: PreviewProvider {
        static var previews: some View {
            WeatherWidget()
        }
    }
    
    
    struct WeatherDatas: Codable {
//        let weather: Array<[String: String]>
        let name: String
        let main: Main
    }
//
//    struct Weather: Codable {
//        let main: String
//        let description: String
//        let icon: String
//    }
    
    struct Main: Codable {
        let temp: Double
        let temp_max: Double
        let temp_min: Double
        let humidity: Double
    }
    
    
}
