//
//  SignInDataSource.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 1/30/17.
//  Copyright © 2017 victorW. All rights reserved.
//

import UIKit


class SignInData {
    
    
    
    enum Fields {
        
        case fName
        case lName
        case email
        case password
        case confirmPassword
        case bio
        
        static var count: Int {
            return 6
        }
    }
    
    
    var fName: String?
    var lName: String?
    var email: String?
    var password: String?
    var passwordConfirm: String?
    var bio: String?
    
    var userImg: UIImage?
    
    
    
    
}
