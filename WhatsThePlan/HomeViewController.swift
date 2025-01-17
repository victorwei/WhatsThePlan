//
//  ViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 11/15/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import Parse

let API_Key = "AIzaSyAC42N5Px8GYaC7hxetG-_iT9YLMLpC3b4"


class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var autoCompleteController: CitySearchResultsController!
    var resultsArray: [String] = []
    var searchController: UISearchController!
    var locationController: LocationController!
    var currentCityController: CurrentCityController!

    
    
    
    //setup dummy data
    var cities = ["San Francisco, CA", "Los Angeles, CA", "New York, NY", "Atlanta, GA", "Denver, CO"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func setup() {
        
        locationController = LocationController()
        currentCityController = CurrentCityController()
        
        //get the current city
        currentCityController.requestUserLocation()
        
        
        //initialize the autoCompleteController
        autoCompleteController = CitySearchResultsController()
        autoCompleteController.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        
        let cityNibCell = UINib(nibName: "CityTableViewCell", bundle: nil)
        tableView.register(cityNibCell, forCellReuseIdentifier: "CityTableViewCell")
        
        
        searchBar.barTintColor = UIColor.appTheme
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.appTheme.cgColor
        
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.appTheme
        
        self.navigationItem.title = "What's The Plan"
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func goToCityView(cityString: String) {
        City.sharedInstance.cityName = cityString
        
        locationController.getLatLongFromCity(cityName: cityString) { (result, lat, lng, placeId) in
            if result {
                //do something
                City.sharedInstance.latitude = lat
                City.sharedInstance.longitude = lng
                
            } else {
                //display error message could not get lat/lng
                print("Couldn't get lat/lng for city")
                return
                
            }
            
        }
        
        self.tabBarController?.selectedIndex = 1
        
        
    }
    
}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchController = UISearchController(searchResultsController: autoCompleteController)
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
//        definesPresentationContext = false
        searchController.searchBar.barTintColor = UIColor.appTheme
        
        self.present(searchController, animated: true, completion: nil)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let placesClient = GMSPlacesClient()
        
        //set filter to only show results for cities
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        filter.country = "US"
        
        
        //get the autuComplete queries and add them to the results array
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter, callback: { [unowned self] (results, error) -> Void in
            
            self.resultsArray.removeAll()
            
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            
            for result in results! {
                
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            self.autoCompleteController.reloadDataFromArray(array: self.resultsArray)
        })
        
        
    }
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        cell.label.text = cities[indexPath.row]
        
        
        DispatchQueue.global(qos: .default).async {
            
            self.locationController.getLatLongFromCity(cityName: self.cities[indexPath.row], completion: { (success, lat, lng, placeId) in
                
                if success {
                    
                    self.locationController.getCitiesPicture(placeId: placeId!, completion: { (success, photo) in
                        if success {
                            
                            DispatchQueue.main.async {
                                cell.imgView.image = UIImage(data: photo!)
                            }
                            
                        }
                    })
                    
                }
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 3.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        
        goToCityView(cityString: city)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension HomeViewController: presentCityView {

    func presentCityView(cityString: String) {

        goToCityView(cityString: cityString)
        
    }
}
