//
//  AddLocationViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/4/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddLocationViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var addSearchBtn: UIBarButtonItem!
    @IBOutlet weak var googleMapContainer: UIView!
    
    var googleMapView: GMSMapView!
    var autoCompleteController: LocationSearchResultsController!
    var resultsArray: [String] = []
    var locations: [String] = []
    var markerArray: [GMSMarker] = []
    weak var delegate: GetLocationsProtocol!

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setup() {
        
        //create the googleMap view, set its initial camera, and add the view to the superview
        googleMapView = GMSMapView(frame: self.googleMapContainer.frame)
        let camera = GMSCameraPosition.camera(withLatitude: City.sharedInstance.latitude, longitude: City.sharedInstance.longitude, zoom: 11.5)
        googleMapView.camera = camera
        self.view.addSubview(googleMapView)
        
        googleMapView.delegate = self
        autoCompleteController = LocationSearchResultsController()
        autoCompleteController.delegate = self
        
    }
    
    
    //MARK: - IBActions

    @IBAction func addLocation(_ sender: Any) {
        
        let searchBar = UISearchController(searchResultsController: autoCompleteController)
        searchBar.searchBar.delegate = self
        present(searchBar, animated: true, completion: nil)
    }
    
    
    @IBAction func saveLocations(_ sender: Any) {
        if markerArray.count == 0 {
            //display error message
            
        } else {
            
            delegate.getLocations(markers: markerArray, locations: locations)
            dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    
    
}


// MARK: - Protocol for getting data from Search Controller

extension AddLocationViewController: LocateOnMap {
    func locateOnMap(data: NSDictionary) {
        
        //Get data from NSDictionary and get lat/lng
        guard let geometry = data["geometry"] as? NSDictionary,
        let location = geometry["location"] as? NSDictionary else {
            print("Location not found")
            return
        }
        let latitude = location["lat"] as! Double
        let longitude = location["lng"] as! Double

        //get location proper name
        let locationName = data["name"] as! String
        
        
        //create marker/annotation for google maps and add it to the marker array
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let marker = GMSMarker(position: coordinate)
        marker.title = locationName
        markerArray.append(marker)
        
        //reposition the map camera to the new marker
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        googleMapView.camera = camera
        
        marker.map = googleMapView
        
        
        //Get the location place id for future reference
        guard let id = data["place_id"] as? String else {
            print("Place id doesn't exist for this location")
            return
        }
        
        locations.append(id)
        
        
    }
}


// MARK: - SearchBar Delegate

extension AddLocationViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        let placesClient = GMSPlacesClient()
        
        //create the bounds to search for so we don't get results from other cities
        let offset = 200.0/1000.0
        let cityLat = City.sharedInstance.latitude
        let cityLng = City.sharedInstance.longitude
        
        //set the northwest coordinate and southeast coordinate of where searches will occur
        let latMax = cityLat! + offset;
        let latMin = cityLat! - offset;
        let lngOffset = offset * cos(cityLat! * M_PI / 200.0);
        let lngMax = cityLng! + lngOffset;
        let lngMin = cityLng! - lngOffset;
        //create the CLLocation from the above values
        let initialLocation = CLLocationCoordinate2D(latitude: latMax, longitude: lngMax)
        let otherLocation = CLLocationCoordinate2D(latitude: latMin, longitude: lngMin)
        
        //create the CoordinateBounds from the CLLocations. and search based the text
        let bounds = GMSCoordinateBounds(coordinate: initialLocation, coordinate: otherLocation)

        
        //get the autoComplete queries and add them to the results array
        placesClient.autocompleteQuery(searchText, bounds: bounds, filter: nil, callback: { [unowned self] (results, error) -> Void in
            
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
            self.autoCompleteController.reloadDataFromArray(results: self.resultsArray)
        })
        
    }
    
}




// MARK: - GoogleMap Delegate

extension AddLocationViewController: GMSMapViewDelegate {
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        deleteMarkerAlert(marker: marker)
    }
    
    
    func deleteMarkerAlert(marker: GMSMarker) {
        
        let alertController = UIAlertController(title: "Remove Marker?", message: "Remove this location from your sugggestion?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Remove", style: .destructive) { (UIAlertAction) in
            
            //Iterate through markes in marker array, remove the marker from the map and then delete it from the array
            for index in 0..<self.markerArray.count {
                if self.markerArray[index] == marker {
                    marker.map = nil
                    self.markerArray.remove(at: index)
                    self.locations.remove(at: index)
                    break
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - Protocol to pass location data back
protocol GetLocationsProtocol: NSObjectProtocol {
    func getLocations (markers: [GMSMarker], locations: [String])
}

