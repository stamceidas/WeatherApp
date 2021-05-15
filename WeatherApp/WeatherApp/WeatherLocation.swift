//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 15/5/21.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var address: String
    var latitude: Double
    var longtitude: Double
    
    init(name: String, address: String, latitude: Double, longtitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longtitude = longtitude
    }
}
