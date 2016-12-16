//
//  City.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/4/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class City: NSObject {
    
    var cityName: String!
    var latitude: Double!
    var longitude: Double!
    
    static let sharedInstance = City()
    
    private override init() {}
    



}
