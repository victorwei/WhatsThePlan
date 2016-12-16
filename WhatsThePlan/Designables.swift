//
//  Designables.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/8/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class Designables: NSObject {

}



@IBDesignable class UserImage: UIImageView {
    
    @IBInspectable var cornerRadius : CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0 }
    }
    
}
