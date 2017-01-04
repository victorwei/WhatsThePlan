//
//  CityViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/2/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker


class CityViewController: UIViewController{

    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    var autoCompleteController: CitySearchResultsController!
    var resultsArray: [String] = []
    var searchController: UISearchController!
    var locationAdapter = LocationController()
    
    let cityViewModel = CityViewModel()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.placeholder = City.sharedInstance.cityName
        setupTableViewModelData()
        
    }
    
    
    func setup() {
        
        //tableview setup
        tableView.delegate = self
        tableView.dataSource = self
        
        let cityNib = UINib(nibName: "CityResultsTableViewCell", bundle: nil)
        tableView.register(cityNib, forCellReuseIdentifier: "cityCell")
        
        
        
        
        //search results setup
        autoCompleteController = CitySearchResultsController()
        autoCompleteController.delegate = self

        
        //search bar setup
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        

        
    }
    
    
    
    func setupTableViewModelData() {
        
        cityViewModel.getPlansForCity { [unowned self] (success) in
            if success {
                self.tableView.reloadData()
            } else {
                
                //alert user city view model was not able to get data
            }
        }
        

    }
    
    
    

    // MARK: - IBActions
    
    @IBAction func addLocations(_ sender: Any) {
        
        //let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        
        //let destinationNC = UINavigationController(rootViewController: destinationVC)
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreatePlanViewController") as! CreatePlanViewController
        
        let destinationNC = UINavigationController(rootViewController: destinationVC)
        
        present(destinationNC, animated: true, completion: nil)
        
        
    }

}




extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityViewModel.cityResults.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityResultsTableViewCell
        
        
        //get user data
        let plan = cityViewModel.cityResults[indexPath.row]
        cell.planTitleLabel.text = plan.title
        cell.cityLabel.text = City.sharedInstance.cityName
        
        DispatchQueue.global(qos: .background).async {
            self.cityViewModel.getUserInfoForPlan(userObjectId: plan.userId!) { (success) in
                if success {
                    DispatchQueue.main.async {
                        let userPhoto = self.cityViewModel.user["photo"] as! Data
                        let first_name = self.cityViewModel.user["firstName"] as! String
                        let last_name = self.cityViewModel.user["lastName"] as! String
                        let name = first_name + " " + String(describing: last_name.characters.first!)
                        cell.userLabel.text = name
                        cell.imgView.image = UIImage(data: userPhoto)
                    }
                }
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlanViewController") as! PlanViewController
        
        destinationVC.plan = cityViewModel.cityResults[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    
    
    
    
}


extension CityViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchController = UISearchController(searchResultsController: autoCompleteController)
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        //        definesPresentationContext = false
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


extension CityViewController: presentCityView {
    
    func presentCityView(cityString: String) {
        
        self.searchBar.placeholder = cityString
        
        City.sharedInstance.cityName = cityString
        
        locationAdapter.getLatLongFromCity(cityName: cityString) { (result, lat, lng, placeId) in
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
        
        
        //reload data
        cityViewModel.getPlansForCity { [unowned self] (success) in
            if success {
                self.tableView.reloadData()
            }
        }
        
        
        
    }
}
