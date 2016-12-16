//
//  Database.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/12/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import Parse


class Database: NSObject {
    
    static let sharedInstance =  Database()
    private override init () {}

    
    func addUser(firstName: String, lastName: String, bio: String, photo: Data, email: String, password: String,
                 completion: @escaping (_ success: Bool) -> ()){


        let userObject = PFUser()
        userObject["firstName"] = firstName
        userObject["lastName"] = lastName
        userObject["bio"] = bio
        //userObject["photo"] = photo
        //required fields
        userObject.email = email
        userObject.password = password
        userObject.username = email
        
        let photoFile = PFFile(name: "userPhoto.png", data: photo)
        userObject["userPhoto"] = photoFile
        
        
        userObject.signUpInBackground(block: { (success, error) in
            if success {
                print("User successfully saved to database")
                completion(true)
            } else {
                print("\(error?.localizedDescription)")
                completion(false)
            }
        })
        
    }
    
    
    func login(email: String, password: String, completion: @escaping (_ result: Bool) ->()) {
        
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            
            if user != nil {
                
                let first_name = user?["firstName"] as! String
                let last_name = user?["lastName"] as! String
                let bio = user?["bio"] as! String
                let email = user?.email
                
                let photo = user?["userPhoto"] as! PFFile
                photo.getDataInBackground(block: { (data, error) in
                    if error == nil {
                        if let imageData = data {
                            User.sharedInstance.picture = imageData
                        }
                        
                        
                    }
                })
                
                let userId = user?.objectId
                
                User.sharedInstance.firstName = first_name
                User.sharedInstance.lastName = last_name
                User.sharedInstance.email = email
                User.sharedInstance.bio = bio
                User.sharedInstance.userId = userId
                completion(true)
                
            } else {
                completion(false)
            }
        }
    }
    
    
    
    func getCurrentUserInfo (completion: ( _ valid: Bool) -> ()) {
      
        var user = PFUser.current()
        if user != nil {
            
            let first_name = user?["firstName"] as! String
            let last_name = user?["lastName"] as! String
            let bio = user?["bio"] as! String
            let email = user?.email
            
            let photo = user?["userPhoto"] as! PFFile
            photo.getDataInBackground(block: { (data, error) in
                if error == nil {
                    if let imageData = data {
                        User.sharedInstance.picture = imageData
                    }
                    
                    
                }
            })
            
            let userId = user?.objectId
            
            User.sharedInstance.firstName = first_name
            User.sharedInstance.lastName = last_name
            User.sharedInstance.email = email
            User.sharedInstance.bio = bio
            User.sharedInstance.userId = userId
            completion(true)
            
        } else {
            
            completion(false)
        }
   
    }
    
    
    func getSpecificUserInfo (userId: String, completion: @escaping (_ success: Bool, _ userInfo: [String: Any]) -> ()) {
        
        let user: PFUser = try! PFQuery.getUserObject(withId: userId)
        
        var userInfo = Dictionary<String, Any>()
        
        
        let first_name = user["firstName"] as! String
        let last_name = user["lastName"] as! String
        let bio = user["bio"] as! String
        let email = user.email
        
        
        
        userInfo["firstName"] = first_name
        userInfo["lastName"] = last_name
        userInfo["bio"] = bio
        userInfo["email"] = email
        
        let photo = user["userPhoto"] as! PFFile
        photo.getDataInBackground(block: { (data, error) in
            if error == nil {
                if let imageData = data {
                    
                    userInfo["photo"] = imageData
                    completion(true, userInfo)
                    
                }
            } else {
                completion(false, [:])
            }
        })

        
        
        
        
        
        
    }
    
    func verifyUniqueEmail (email: String, completion: @escaping ( _ valid: Bool) -> ()) {
        
        let query = PFQuery(className: "User")
        query.whereKey("email", equalTo: email)
        
        query.findObjectsInBackground { (objects, error) in
            
            if !(error != nil) {
                completion(true)
            } else {
                print("\(error?.localizedDescription)")
                completion(false)
            }
        }
    }
    
    
    func savePlan (shortDescription: String, plan: String, city: String, locations: [String], completion: @escaping (_ result: Bool)-> ()) {
        
        let currentUser = PFUser.current()
        let userId = currentUser?.objectId
        
        
        let planObject = PFObject(className: "Plans")
        planObject["user"] = userId
        planObject["description"] = shortDescription
        planObject["plan"] = plan
        planObject["city"] = city
        

        
        let locationObject = PFObject(className: "Locations")
        locationObject.addObjects(from: locations, forKey: "locationId")
        
        locationObject["parent"] = planObject
        
        locationObject.saveInBackground { (success, error) in
            if success {
                print("success!")
                completion(true)
            }
        }
    }
    
    
    
    
    func getPlan (city: String, completion: @escaping (_ result: Bool, _ plan: [[String]], _ pfObject: [PFObject]) ->()) {
        
        
        let query = PFQuery(className: "Plans")
        query.whereKey("city", equalTo: city)
        
        query.findObjectsInBackground { (objects, error) in
            if !(error != nil) {
                
                var objectResult: [[String]] = []
                
                for object in objects! {
                    
                    var objectArray: [String] = []
                    
                    let userId = object["user"] as! String
                    let description = object["description"] as! String
                    let plan = object["plan"] as! String
                    let planId = object.objectId
                    
                    objectArray.append(userId)
                    objectArray.append(description)
                    objectArray.append(plan)
                    objectArray.append(city)
                    objectArray.append(planId!)
                    
                    objectResult.append(objectArray)
                }
                
                completion(true, objectResult, objects!)
                
            } else {
                completion(false, [], objects!)
            }
        }
    }
    
    
    func getLocationsForPlan( pfObject: PFObject, completion: @escaping (_ result: Bool, _ locations: [String]) -> ()) {
        
        let query = PFQuery(className: "Locations")
        query.whereKey("parent", equalTo: pfObject)
        
        query.findObjectsInBackground { (objects, error) in
            
            if !(error != nil) {
                
                guard let locationObjects = objects else {
                    print("No locations found for this plan!")
                    return
                }
                
                
                let locations = locationObjects[0].value(forKey: "locationId") as! [String]
                
                completion(true, locations)
            } else {
                print("\(error?.localizedDescription)")
            }
        }
        
        
    }
    
    
    
}
