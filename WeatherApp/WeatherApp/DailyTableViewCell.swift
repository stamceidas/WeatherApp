//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 16/5/21.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    var dailyWeather: DailyWeather! {
        didSet {
            weekDayLabel.text = dailyWeather.dailyDay
            highTempLabel.text = dailyWeather.dailyHigh
            lowTempLabel.text = dailyWeather.dailyLow
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.systemBlue
            selectedBackgroundView = backgroundView
        }
    }
}
