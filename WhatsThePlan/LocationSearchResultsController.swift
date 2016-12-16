//
//  locationSearchResultsController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/4/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class LocationSearchResultsController: UITableViewController {
    
    // MARK: - Properties
    var searchResults: [String]!
    weak var delegate: LocateOnMap!
    var locationController = LocationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchResults = [String]()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationResultsCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationResultsCell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        locationController.getLocationData(locationName: searchResults[indexPath.row]) { (result, data) in
            if result {
                delegate.locateOnMap(data: data!)
            } else {
                //Display error message unable to find more information on the location selected
                print("Couldn't get more detailed info")
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK: - Helper Functions
    func reloadDataFromArray(results: [String]) {
        searchResults = results
        tableView.reloadData()
    }
}




// MARK: - Protocol to send information back to AddLocationViewController 

protocol LocateOnMap: NSObjectProtocol {
    func locateOnMap(data: NSDictionary)
}
