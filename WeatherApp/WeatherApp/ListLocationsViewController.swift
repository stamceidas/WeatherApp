//
//  ListLocationsViewController.swift
//  WeatherApp
//
//  Created by Stamatis Stroumpis on 15/5/21.
//

import UIKit
import GooglePlaces

class ListLocationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var weatherLocations: [WeatherLocation] = [] {
        didSet {
            saveLocations()
        }
    }
    var selectedLocationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func saveLocations() {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(weatherLocations) else {
            print("Error saving encoded locations!")
            return
        }
        UserDefaults.standard.set(encoded, forKey: "weatherLocations")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedLocationIndex = tableView.indexPathForSelectedRow!.row
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify a city filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        tableView.setEditing(tableView.isEditing ? false : true, animated: true)
        sender.title = tableView.isEditing ? "Edit" : "Done"
        addButton.isEnabled = tableView.isEditing ? true : false
    }

}

extension ListLocationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        cell.detailTextLabel?.text = weatherLocations[indexPath.row].address
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        weatherLocations.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        //saveData()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = weatherLocations[sourceIndexPath.row]
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(rowToMove, at: destinationIndexPath.row)
    }
}

extension ListLocationsViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name ?? "")")
    print("Place ID: \(place.placeID ?? "")")
    print("Place attributions: \(place.attributions ?? NSAttributedString(string: ""))")
    
    let placesLocation = WeatherLocation(name: place.name ?? "Unknown Location Name", address: place.formattedAddress ?? "Unknown Address", latitude: place.coordinate.latitude, longtitude: place.coordinate.longitude)
    weatherLocations.append(placesLocation)
    tableView.reloadData()
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

}

