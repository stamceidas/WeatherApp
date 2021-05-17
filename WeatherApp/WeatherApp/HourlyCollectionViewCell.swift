//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 16/5/21.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var hourlyTemperature: UILabel!
    
    var hourlyWeather: HourlyWeather! {
        didSet {
            hourLabel.text = hourlyWeather.hourlyHour
            iconImageView.image = UIImage()
            hourlyTemperature.text = hourlyWeather.hourlyTemp
        }
    }
    
}
