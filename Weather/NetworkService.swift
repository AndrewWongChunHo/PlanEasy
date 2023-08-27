//
//  NetworkService.swift
//  Weather
//
//  Created by Max Kuznetsov on 26.08.2022.
//

let json =
"""
{
  "data": {
    "timelines": [
      {
        "timestep": "1d",
        "endTime": "2023-05-18T10:00:00Z",
        "startTime": "2023-05-12T10:00:00Z",
        "intervals": [
          {
            "startTime": "2023-05-12T10:00:00Z",
            "values": {
              "temperature": 24.46,
              "weatherCode": 1000
            }
          },
          {
            "startTime": "2023-05-13T10:00:00Z",
            "values": {
              "temperature": 25.09,
              "weatherCode": 1000
            }
          },
          {
            "startTime": "2023-05-14T10:00:00Z",
            "values": {
              "temperature": 26.12,
              "weatherCode": 4201
            }
          },
          {
            "startTime": "2023-05-15T10:00:00Z",
            "values": {
              "temperature": 25,
              "weatherCode": 4201
            }
          },
          {
            "startTime": "2023-05-16T10:00:00Z",
            "values": {
              "temperature": 25.09,
              "weatherCode": 4000
            }
          },
          {
            "startTime": "2022-05-17T10:00:00Z",
            "values": {
              "temperature": 24.25,
              "weatherCode": 1001
            }
          },
          {
            "startTime": "2022-05-18T10:00:00Z",
            "values": {
              "temperature": 25.6,
              "weatherCode": 4000
            }
          }
        ]
      }
    ]
  }
}
"""


import Foundation

final class NetworkService{
    
    typealias weatherTuple = (date: Date, temperature: Double, weatherCode: Int)
        
    private let url = "https://api.tomorrow.io/v4/timelines?location=22.3193,114.1694&fields=temperature&fields=weatherCode&units=metric&timesteps=1d&startTime=now&endTime=nowPlus6d&apikey=Tz8FKVghB6uiU8pgKwxiKrZd2p6hwows"
    
    func performWeatherRequest(completion: @escaping ([weatherTuple]) -> Void){
            URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                guard let data = data else {
                    return
                }
                
                let weather: WeatherModel = try! JSONDecoder().decode(WeatherModel.self, from: json.data(using: .utf8)!)
                let intervals = weather.data.timelines[0].intervals

                var tupleArray: [weatherTuple] = []
                                
                for interval in intervals{
                    let tempTuple: weatherTuple = (ISO8601DateFormatter().date(from: interval.startTime)!, interval.values.temperature,  interval.values.weatherCode)

                    tupleArray.append(tempTuple)
                }
                completion(tupleArray)
                
            }.resume()
    }
    
}
