//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 15/5/21.
//

import UIKit

class LocationDetailViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentWeatherDetail: WeatherDetail!
    var weatherLocationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    

    
    func updateUI() {
        let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        let weatherLocation = pageVC.weatherLocations[weatherLocationIndex]
        currentWeatherDetail = WeatherDetail(name: weatherLocation.name, address: weatherLocation.address, latitude: weatherLocation.longtitude, longtitude: weatherLocation.longtitude)
        locationLabel.text = currentWeatherDetail.name
        weatherDescriptionLabel.text = currentWeatherDetail.address
        temperatureLabel.text = "--°"
        
        pageControl.numberOfPages = pageVC.weatherLocations.count
        pageControl.currentPage = weatherLocationIndex
        currentWeatherDetail.getData {
            DispatchQueue.main.async {
                self.weatherDescriptionLabel.text = self.currentWeatherDetail.description
                self.locationLabel.text = self.currentWeatherDetail.name
                self.temperatureLabel.text = self.currentWeatherDetail.temperature
                if let iconURL = URL(string: self.currentWeatherDetail.weatherIconUrl) {
                    self.weatherImageView.load(url: iconURL)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let targetController = segue.destination as? UINavigationController,
           let destination = targetController.topViewController as? ListLocationsViewController {
            let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            destination.weatherLocations = pageVC.weatherLocations
        }
    }
    
    @IBAction func unwindFromVC(segue: UIStoryboardSegue) {
        if let source = segue.source as? ListLocationsViewController {
            weatherLocationIndex = source.selectedLocationIndex
            let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            pageVC.weatherLocations = source.weatherLocations
            pageVC.setViewControllers([pageVC.createLocationDetailVC(forPage: weatherLocationIndex)], direction: .forward, animated: false, completion: nil)
        }
    }
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        var direction: UIPageViewController.NavigationDirection = .forward
        if sender.currentPage < weatherLocationIndex {
            direction = .reverse
        }
        
        pageVC.setViewControllers([pageVC.createLocationDetailVC(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)
        
    }
}
