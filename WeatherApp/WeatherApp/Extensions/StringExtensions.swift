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
}
