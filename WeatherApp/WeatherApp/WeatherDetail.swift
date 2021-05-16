//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 16/5/21.
//

import Foundation

struct DailyWeather {
    var dailyDay: String
    var dailyHigh: String
    var dailyLow: String
}

struct HourlyWeather {
    var hourlyTemp: String
    var hourlyIcon: String
    var hourlyDesc: String
    var hourlyHour: String
}

class WeatherDetail: WeatherLocation {
    
    private struct Result: Codable {
        var data: DataResult
    }
    
    private struct DataResult: Codable {
        var current_condition: [Current]
        var weather: [dailyWeather]
    }
    
    private struct Current: Codable {
        var temp_C: String
        var weatherIconUrl: [Icon]
        var weatherDesc: [Desc]
        var observation_time: String
    }
    
    private struct Icon: Codable {
        var value: String
    }
    
    private struct Desc: Codable {
        var value: String
    }
    
    private struct dailyWeather: Codable {
        var date: String
        var mintempC: String
        var maxtempC: String
        var hourly: [hourlyWeather]
    }
    
    private struct hourlyWeather: Codable {
        var tempC: String
        var weatherIconUrl: [Icon]
        var weatherDesc: [Desc]
    }
    
    var currentTime = "00:00"
    var description = ""
    var temperature = ""
    var weatherIconUrl = ""
    var dailyWeatherData: [DailyWeather] = []
    var hourlyWeatherData: [[HourlyWeather]] = []
    
    func getData(completed: @escaping() -> ()) {
        let urlString = "http://api.worldweatheronline.com/premium/v1/weather.ashx?key=\(ApiKeys.worldWeather)&q=\(name)&format=json&tp=1&mca=no&num_of_days=5"
        
        guard let url = URL(string: urlString) else {
            print("Error! Could not create valid url from \(urlString)")
            completed()
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            
            do {
                let result = try JSONDecoder().decode(Result.self, from: data!)
                print("😎 \(result)")
                self.currentTime = result.data.current_condition[0].observation_time
                self.temperature = "\(result.data.current_condition[0].temp_C)°"
                self.description = result.data.current_condition[0].weatherDesc[0].value
                self.weatherIconUrl = result.data.current_condition[0].weatherIconUrl[0].value
                
                result.data.weather.enumerated().forEach { (index,day) in
                    let dailyHigh = "H: \(result.data.weather[index].maxtempC)°"
                    let dailyLow = "L: \(result.data.weather[index].mintempC)°"
                    var dailyDay = ""
                    if let date = result.data.weather[index].date.getDate() {
                        dailyDay = date.getWeekDay()
                    }
                    let dailyWeather = DailyWeather(dailyDay: dailyDay, dailyHigh: dailyHigh, dailyLow: dailyLow)
                    self.dailyWeatherData.append(dailyWeather)
                    
                    
                    var dayHourlyWeather : [HourlyWeather] = []
                    result.data.weather[index].hourly.enumerated().forEach { (indexHour, day) in
                        let hourlyTemp = "\(result.data.weather[index].hourly[indexHour].tempC)°"
                        let hourlyIcon = result.data.weather[index].hourly[indexHour].weatherIconUrl[0].value
                        let hourlyDesc = result.data.weather[index].hourly[indexHour].weatherDesc[0].value
                        let hourlyHour = String(indexHour).convertDateFormater()
                        
                        let hourlyWeather = HourlyWeather(hourlyTemp: hourlyTemp, hourlyIcon: hourlyIcon, hourlyDesc: hourlyDesc, hourlyHour: hourlyHour)
                        dayHourlyWeather.append(hourlyWeather)
                    }
                    self.hourlyWeatherData.append(dayHourlyWeather)
                }
                
            } catch {
                print("Json Error \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
}
