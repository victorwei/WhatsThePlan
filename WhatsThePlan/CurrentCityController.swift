//
//  CurrentCityController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/7/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import CoreLocation


class CurrentCityController: NSObject {
    
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    
    func requestUserLocation() {
        
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
        }
        
    }
    
    
    func getCityFromCoordinates(lat: CLLocationDegrees, lng: CLLocationDegrees){
        let location = CLLocation(latitude: lat, longitude: lng)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                let city = pm.locality! as String
                let state = pm.administrativeArea! as String
                //protocol delegate function used to return the city to the VC that conforms to the protocol
                //print("\(city)")
                let fullCity = city + ", " + state
                City.sharedInstance.cityName = fullCity
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
            
        }
        
    }
    

}


extension CurrentCityController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first
        
        if location != nil {
            let lat = location?.coordinate.latitude
            let lng = location?.coordinate.longitude
            
            getCityFromCoordinates(lat: lat!, lng: lng!)
            
            City.sharedInstance.latitude = lat as Double!
            City.sharedInstance.longitude = lng as Double!
            
            
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("Failed to find the user's location : \(error.localizedDescription)")
    }
    
}
