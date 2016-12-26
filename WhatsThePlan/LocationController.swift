//
//  LocationController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/2/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit


class LocationController: NSObject {
    
    private let baseURLforLocation = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    private let baseURLforCity = "https://maps.googleapis.com/maps/api/geocode/json?address="
    private let baseURLforPhotos = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000"
    private let baseURLforDetails = "https://maps.googleapis.com/maps/api/place/details/json?placeid="
    private let googleAPIkey = "AIzaSyD9otanbg6qP9DvIxWfLExAfCg1q8wQJxo"
    
    
    
    
    
    
    
    func getLatLongFromCity(cityName: String, completion: (_ result: Bool, _ latitude: Double?, _ longitude: Double?)-> ()) {
        
        //set the url string as data and get the JSON serialization of it
        let cityString = cityName.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "\(baseURLforCity)\(cityString)&key=\(googleAPIkey)")
        let data = try! Data(contentsOf: url!)
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        
        //check for a valid json result
        guard json["status"] as? String == "OK" else {
            print("do something")
            completion(false, nil, nil)
            return
        }
        //parse the json result to grab the latitude and longitude values
        guard let results = json["results"] as? NSArray,
            let firstEntry = results[0] as? NSDictionary,
            let geometry = firstEntry["geometry"] as? NSDictionary,
            let location = geometry["location"] as? NSDictionary else {
               print("Location not found")
                completion(false, nil, nil)
                return
        }
        
        let latitude = location["lat"] as! Double
        let longitude = location["lng"] as! Double
        completion(true, latitude, longitude)
        

    }
    
    
    
    func getLatLngFromLocation(locationName: String, completion: (_ result: Bool, _ latitude: Double?, _ longitude: Double?)-> ()) {
        
        let urlString = "\(baseURLforLocation)\(City.sharedInstance.latitude!),\(City.sharedInstance.longitude!)&radius=18000&name=\(locationName)&key=\(googleAPIkey)"
        let correctUrl = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let url = URL(string: correctUrl!)
        let data = try! Data(contentsOf: url!)
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        
        //check for a valid json result
        guard json["status"] as? String == "OK" else {
        print("do something")
        completion(false, nil, nil)
        return
        }
        //parse the json result to grab the latitude and longitude values
        guard let results = json["results"] as? NSArray,
        let firstEntry = results[0] as? NSDictionary,
        let geometry = firstEntry["geometry"] as? NSDictionary,
        let location = geometry["location"] as? NSDictionary else {
        print("Location not found")
        completion(false, nil, nil)
        return
        }
        
        let latitude = location["lat"] as! Double
        let longitude = location["lng"] as! Double
        completion(true, latitude, longitude)
    }

    
    func getLocationData(locationName: String, completion: (_ result: Bool, _ data: NSDictionary?)-> ()) {
        
        let urlString = "\(baseURLforLocation)\(City.sharedInstance.latitude!),\(City.sharedInstance.longitude!)&radius=18000&name=\(locationName)&key=\(googleAPIkey)"
        let correctUrl = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let url = URL(string: correctUrl!)
        let data = try! Data(contentsOf: url!)
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        
        //check for a valid json result
        guard json["status"] as? String == "OK" else {
            print("do something")
            completion(false, nil)
            return
        }
        //parse the json result to grab the first result
        guard let results = json["results"] as? NSArray,
            let firstEntry = results[0] as? NSDictionary else {
                print("Location not found")
                completion(false, nil)
                return
        }
        
        completion(true, firstEntry)
        
    }
    
    
    
    //Get the hours of operation for the location.  Requires a NSDictionary object and returns an array of strings
    func getLocationAvailability (data: NSDictionary) -> [String]? {
        var results: [String]?
        guard let hours = data["opening_hours"] as? NSDictionary,
            let openWeek = hours["weekday_text"] as? NSArray else {
                return nil
        }
        results = []
        for day in openWeek {
            results?.append((day as? String)!)
        }
        return results
        
        
    }
    

    
    //Ge the types object for a location object.  Function requires a NSDictionary object and returns an array if strubgs
    func getTypesForLocation (data: NSDictionary) -> [String]? {
        var results: [String]?
        
        guard let types = data["types"] as? NSArray else {
            return results
        }
        results = []
        for type in types {
            if type as? String == "point_of_interest" {
                break
            }
            results?.append(type as! String)
        }
        return results
    }
    
    //get picture
    func getPictureForLocation(data: NSDictionary) -> Data? {
        
        guard let photos = data["photos"] as? NSArray,
            let photo = photos[0] as? NSDictionary,
            let photoRef = photo["photo_reference"] as? String else {
                return nil
        }
        let url = URL(string: "\(baseURLforPhotos)&photoreference=\(photoRef)&key=\(googleAPIkey)")
        let data = try! Data(contentsOf: url!)
        return data
        
    }
    
    
    func getLocationCoordinates(data: NSDictionary) -> (Double, Double)?{
        
        guard let geometry = data["geometry"] as? NSDictionary,
            let location = geometry["location"] as? NSDictionary else {
                return nil
        }
        let lat = location["lat"] as! Double
        let lng = location["lng"] as! Double
        
        return (lat, lng)
    }
    
    
    
    func getLocationDetails(placeId: String, completion: (_ result: Bool, _ data: [String: Any]?)->()) {
        
        let urlString = "\(baseURLforDetails)\(placeId)&key=\(googleAPIkey)"
        let url = URL(string: urlString)
        let data = try! Data(contentsOf: url!)
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        
        //check for a valid json result
        guard json["status"] as? String == "OK",
            let result = json["result"] as? NSDictionary else {
                print("do something")
                completion(false, nil)
                return
        }
        
        //get address
        let address = result["formatted_address"] as? String
        
        //get phonenumber
        let phone = result["formatted_phone_number"] as? String
        
        //get website
        let website = result["website"] as? String
        
        //get rating
        let rating = result["rating"] as? Float
        
        //get price
        let price = result["price_level"] as? Int
        
        //get name
        let name = result["name"] as? String
        
        //get types
        let types = getTypesForLocation(data: result)
        
        //get availability
        let availability = getLocationAvailability(data: result)
        
        //get picture
        let picture = getPictureForLocation(data: result)
        
        //get latitude
        let coordinates = getLocationCoordinates(data: result)
        
        let latitude = coordinates?.0
        let longitude = coordinates?.1
        
        
    
        var locationData = Dictionary<String, Any>()
        locationData["name"] = name
        locationData["address"] = address
        locationData["phone"] = phone
        locationData["website"] = website
        locationData["rating"] = rating
        locationData["price"] = price
        locationData["availability"] = availability
        locationData["types"] = types
        locationData["picture"] = picture
        locationData["latitude"] = latitude
        locationData["longitude"] = longitude
        
        completion(true, locationData)

    }
    
    
    
    
    
//    func urlsessiontest() {
//        
//        
//        let url = URL(string: "https://itunes.apple.com/us/rss/topalbums/limit=20/json")
//        
////        let data = try! Data(contentsOf: url!)
////        
////        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
////        
////        print(json)
//        
//        let session = URLSession.shared
//        
//        session.dataTask(with: url!) { (data, response, error) in
//            if error != nil {
//                print("\(error?.localizedDescription)")
//                
//            } else {
//                
//                let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
//                print(json)
//            }
//        }.resume()
        
        
//    }

 
}
