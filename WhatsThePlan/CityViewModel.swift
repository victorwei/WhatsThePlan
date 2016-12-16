//
//  CityViewModel.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/14/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class CityViewModel: NSObject {
    
    var cityResults: [Plan] = []
    
    var user: [String: Any] = [:]
    
    
    func getPlansForCity(completion: @escaping (_ result: Bool) -> ()) {
        
        cityResults = []
        
        Database.sharedInstance.getPlan(city: City.sharedInstance.cityName) { [unowned self] (result, plans, pfObjects) in
            
            if result {
                
                for index in 0..<plans.count {
                    
                    let objectPlan = Plan()
                    objectPlan.userId = plans[index][0]
                    objectPlan.title = plans[index][1]
                    objectPlan.plan = plans[index][2]
                    objectPlan.planId = plans[index][4]
                    objectPlan.locationObject = pfObjects[index]
                    
                    
                    
                    
                    
                    
                    
                    self.cityResults.append(objectPlan)
                    
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func getUserInfoForPlan(userObjectId: String, completion: @escaping (_ success: Bool)-> ()) {
        
        user = [:]
        Database.sharedInstance.getSpecificUserInfo(userId: userObjectId) { (success, userData) in
            if success {
                
                self.user = userData
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    
    
    
    
    

}
