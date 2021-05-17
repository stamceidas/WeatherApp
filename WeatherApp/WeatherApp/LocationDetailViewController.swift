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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentWeatherDetail: WeatherDetail!
    var weatherLocationIndex = 0
    var selectedDayIndexPath = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearUI()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        updateUI()
    }
    
    
    
    func clearUI() {
        locationLabel.text = ""
        weatherDescriptionLabel.text = ""
        temperatureLabel.text = ""
        weatherImageView.image = UIImage()
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
                self.tableView.reloadData()
                self.collectionView.reloadData()
                
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
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

extension LocationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWeatherDetail.dailyWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DailyTableViewCell
        cell.dailyWeather = currentWeatherDetail.dailyWeatherData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard selectedDayIndexPath != indexPath.row else { return }
        selectedDayIndexPath = indexPath.row
        collectionView.reloadData()
    }
}

extension LocationDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWeatherDetail.hourlyWeatherData.first?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as! HourlyCollectionViewCell
        hourlyCell.hourlyWeather = currentWeatherDetail.hourlyWeatherData[selectedDayIndexPath][indexPath.row]
        if let iconURL = URL(string: hourlyCell.hourlyWeather.hourlyIcon) {
            hourlyCell.iconImageView.load(url: iconURL)
        }
        return hourlyCell
    }
    
    
}
