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
    
    var currentWeatherLocation: WeatherLocation!
    var weatherLocations: [WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentWeatherLocation == nil {
            currentWeatherLocation = WeatherLocation(name: "Current Location", address: "Panagouli 5, Athens", latitude: 0, longtitude: 0)
            weatherLocations.append(currentWeatherLocation)
        }
        loadLocations()
        updateUI()
    }
    
    func loadLocations() {
        guard let locations = UserDefaults.standard.value(forKey: "weatherLocations") as? Data
        else {
            print("Error Could not load locations!")
            return
        }
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locations) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        }
    }
    
    func updateUI() {
        locationLabel.text = currentWeatherLocation.address
        dateLabel.text = ""
        weatherDescriptionLabel.text = ""
        temperatureLabel.text = "--°"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let targetController = segue.destination as? UINavigationController,
           let destination = targetController.topViewController as? ListLocationsViewController {
            destination.weatherLocations = weatherLocations
        }
    }
    
    @IBAction func unwindFromVC(segue: UIStoryboardSegue) {
        if let source = segue.source as? ListLocationsViewController {
            weatherLocations = source.weatherLocations
            currentWeatherLocation = weatherLocations[source.selectedLocationIndex]
            updateUI()
        }
    }
}
