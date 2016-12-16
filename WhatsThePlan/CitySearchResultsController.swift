//
//  SearchResultsController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 11/16/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class CitySearchResultsController: UITableViewController {
    
    var searchResults: [String]!
    weak var delegate: presentCityView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Dismiss this view
        self.dismiss(animated: true, completion: nil)
        let cityName = searchResults[indexPath.row].getStringUpToSecondOccurence(char: ",")
        
        delegate.presentCityView(cityString: cityName)
        
        print (cityName)
    }
    
    
    // Helper function that reloads the tableView with search results
    func reloadDataFromArray (array: [String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
    
    
}

extension CitySearchResultsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}




//MARK: - String extension.  Function to get substring of a string based on a target character.
extension String {
    
    func getStringUpToSecondOccurence(char: Character) -> String {
        guard let commaIndex = self.characters.index(of: char) else {
            return self
        }
        
        let beginIndex = self.index(commaIndex, offsetBy: 1)
        let beginString = self.substring(to: beginIndex)
        let endString = self.substring(from: beginIndex)
        
        guard let nextIndex = endString.characters.index(of: char) else {
            return self
        }
        
        let lastString = endString.substring(to: nextIndex)
        return beginString + lastString
    }
}


protocol presentCityView: NSObjectProtocol {
    func presentCityView(cityString: String)
}
