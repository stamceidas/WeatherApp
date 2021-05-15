//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 15/5/21.
//

import UIKit

class PageViewController: UIPageViewController {

    var weatherLocations: [WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        self.dataSource = self
        
        loadLocations()
        setViewControllers([createLocationDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    
    func loadLocations() {
        guard let locations = UserDefaults.standard.value(forKey: "weatherLocations") as? Data
        else {
            print("Error! Could not load locations!")
            //TODO: Get user Location
            weatherLocations.append(WeatherLocation(name: "Current Location", address: "Panagouli 5, Athens", latitude: 0, longtitude: 0))
            return
        }
        
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locations) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            print("Error! Could not decode locations")
        }
        
        if weatherLocations.isEmpty {
            weatherLocations.append(WeatherLocation(name: "Current Location", address: "Panagouli 5, Athens", latitude: 0, longtitude: 0))
        }
    }
    
    func createLocationDetailVC(forPage page: Int) -> LocationDetailViewController {
        let detailVC = storyboard!.instantiateViewController(identifier: String(describing: LocationDetailViewController.self)) as! LocationDetailViewController
            detailVC.weatherLocationIndex = page
            return detailVC
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentVC = viewController as? LocationDetailViewController,
           currentVC.weatherLocationIndex > 0 {
            return createLocationDetailVC(forPage: currentVC.weatherLocationIndex - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentVC = viewController as? LocationDetailViewController,
           currentVC.weatherLocationIndex < weatherLocations.count - 1 {
            return createLocationDetailVC(forPage: currentVC.weatherLocationIndex + 1)
        }
        return nil
    }
}
