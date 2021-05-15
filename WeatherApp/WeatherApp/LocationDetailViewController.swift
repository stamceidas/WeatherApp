//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 15/5/21.
//

import UIKit

class LocationDetailViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentWeatherLocation: WeatherLocation!
    var weatherLocationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    

    
    func updateUI() {
        let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        currentWeatherLocation = pageVC.weatherLocations[weatherLocationIndex]
        locationLabel.text = currentWeatherLocation.address
        dateLabel.text = ""
        weatherDescriptionLabel.text = ""
        temperatureLabel.text = "--°"
        
        pageControl.numberOfPages = pageVC.weatherLocations.count
        pageControl.currentPage = weatherLocationIndex
        currentWeatherLocation.getData()
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
