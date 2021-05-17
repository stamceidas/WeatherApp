//
//  StringExtensions.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 16/5/21.
//

import UIKit

extension String {
    func getDate(dateFormat: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }
    
    func convertDateFormater(_ inputFormat: String = "H", outputFormat: String = "ha") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat
        return  dateFormatter.string(from: date!)
        
    }
}
