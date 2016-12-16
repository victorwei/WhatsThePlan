//
//  Plan.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/5/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse

class Plan: NSObject {

    
    private var locationController = LocationController()
    
    var title: String?
    var plan: String?

    
    var locationMarkers: [GMSMarker]?
    let sectionHeaders: [String] = ["Title", "Write a Plan", "Add Locations"]
    var locationIDs: [String]?

    var locations: [LocationInfo]?
    var foodDrinks: [LocationInfo]?
    
    
    var userId: String?
    var planId: String?
    var locationObject: PFObject?
    
    
    
    func getLocationInfo(completion: (_ result: Bool) ->()) {
        
        guard let locationPlaceIds = locationIDs else {
            completion(false)
            return
        }
        
        for location in locationPlaceIds {
            
            locationController.getLocationDetails(placeId: location, completion: { (result, details) in
                if result {
                    
                    let locationInfo = LocationInfo()
                    var isFood: Bool = false
                    
                    if details?["name"] != nil {
                        locationInfo.name = details?["name"] as? String
                    }
                    
                    if details?["address"] != nil {
                        locationInfo.address = details?["address"] as? String
                    }
                    
                    if details?["phone"] != nil {
                        locationInfo.phone = details?["phone"] as? String
                    }
                    if details?["website"] != nil {
                        locationInfo.website = details?["website"] as? String
                    }
                    
                    if details?["rating"] != nil {
                        locationInfo.rating = details?["rating"] as? Float
                    }
                    
                    if details?["price"] != nil {
                        locationInfo.price = details?["price"] as? Int
                    }
                    
                    if details?["availability"] != nil {
                        locationInfo.availability = details?["availability"] as? [String]
                    }
                    
                    if details?["types"] != nil {
                        locationInfo.types = details?["types"] as? [String]
                    }
                    
                    if details?["picture"] != nil {
                        locationInfo.photo = details?["picture"] as? Data
                    }
                    
                    if details?["latitude"] != nil {
                        locationInfo.latitude = details?["latitude"] as? Double
                    }
                    if details?["longitude"] != nil {
                        locationInfo.longitude = details?["longitude"] as? Double
                    }
                    
                    if locationInfo.types != nil {
                        for type in locationInfo.types! {
                            if type ==  "food" || type ==  "bakery" || type ==  "cafe" || type ==  "restaurant" || type ==  "meal_delivery" || type ==  "meal_takeout" {
                                isFood = true
                                break
                            }
                        }
                    }
                    if isFood{
                        
                        if foodDrinks == nil {
                            foodDrinks = []
                        }
                        foodDrinks?.append(locationInfo)
                    } else {
                        
                        if locations == nil {
                            locations = []
                        }
                        locations?.append(locationInfo)
                    }
                }
            })
        }
        
        completion(true)
        
    }
    
    
    func getMarkerInfo() {
        
        guard let locationsplaces = locations else {
            return
        }
        
        for location in locationsplaces {
            
            let coordinate = CLLocationCoordinate2DMake(location.latitude!, location.longitude!)
            let marker = GMSMarker(position: coordinate)
            marker.title = location.name!
            
            locationMarkers?.append(marker)
    
        }
    }
    
    
}
