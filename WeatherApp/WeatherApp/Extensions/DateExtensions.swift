//
//  DateExtensions.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 16/5/21.
//

import UIKit

extension Date {
    func getWeekDay()-> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let weekDay = dateFormatter.string(from: self)
            return weekDay
      }
}
