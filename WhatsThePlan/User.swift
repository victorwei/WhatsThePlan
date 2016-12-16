//
//  User.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/11/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var firstName: String!
    var lastName: String!
    var picture: Data!
    var reviews: Int!
    var bio: String!
    var userId: String!
    var email: String!
    
    
    static let sharedInstance = User()
    
    private override init(){}

}
