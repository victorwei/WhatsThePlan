//
//  LocationInfo.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/8/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationInfo: NSObject {
    
    
    var name: String?
    var address: String?
    var phone: String?
    var availability: [String]?
    var rating: Float?
    var price: Int?
    var website: String?
    var photo: Data?
    var types: [String]?
    var latitude: Double?
    var longitude: Double?
    
    var marker: GMSMarker?
    
    var locationValues: [String]!
    var locationTypes: [String]!
    
    
    
    func fillOutLocationValues () {
        
        locationTypes = []
        locationValues = []
        
        if name != nil {
            locationTypes.append("name")
            locationValues.append(name!)
        }
        
        if address != nil {
            locationTypes.append("address")
            locationValues.append(address!)
        }
        
        if phone != nil {
            locationTypes.append("phone")
            locationValues.append(phone!)
        }
        
        if website != nil {
            locationTypes.append("website")
            locationValues.append(website!)
        }
        
        
        if rating != nil {
            locationTypes.append("rating")
            locationValues.append(String(rating!))
        }
        
        if price != nil  && price != 0 {
            locationTypes.append("price")
            var priceDollar = ""
            for _ in 0..<price! {
                priceDollar += "$"
            }
            locationValues.append(priceDollar)
        }
        
        if availability != nil {
            locationTypes.append("availability")
            
            var availabilityString = ""
            for member in availability! {
                availabilityString += member + "\n"
            }
            locationValues.append(availabilityString)
        }
    }
    
    
    
    func createMarker() {
        
        let coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        marker = GMSMarker(position: coordinate)
        marker?.title = name!
    }
    
    
    
    

}
