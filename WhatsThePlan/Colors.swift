//
//  Colors.swift
//  DayRec
//
//  Created by Victor Wei on 10/11/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit


//Helper functions used to add a color to UIColor using a hex value
extension UIColor {
    
    //function used to help generate the main netHex function
    convenience init(red: Int, green: Int, blue: Int) {
        //error handling
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    //helper function used to return the color for a hex value
    convenience init (netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    
    class var appTheme: UIColor {
        return UIColor(netHex: 0x7375d6)
    }
    
}

