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



@IBDesignable
class DesignableTextField: UITextField {
    
    
//    @IBInspectable var cornerRadius: CGFloat {
//        didSet{
//            layer.cornerRadius = cornerRadius
//        }
//    }
    
    
    @IBInspectable var leftImage: UIImage? {
        didSet{
            updateView()
        }
        
    }
    
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        
        if let image = leftImage {
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.tintColor = tintColor
            
            var width = leftPadding + 20
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                width = width + 5
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            
            view.addSubview(imageView)
            
            leftView = view
            
            
        } else {
            leftViewMode = .never
        }
        
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName : tintColor])
        
    }
    
    
}




@IBDesignable class UserImage: UIImageView {
    
    @IBInspectable var cornerRadius : CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0 }
    }
    
}



@IBDesignable class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius : CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0 }
    }
    
}


@IBDesignable class customTextView: UITextView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius}
        set { layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0}
    }
    
}


class UIOutlinedLabel: UILabel {
    
    var outlineWidth: CGFloat = 1
    var outlineColor: UIColor = UIColor.white
    
    override func drawText(in rect: CGRect) {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : outlineColor,
            NSStrokeWidthAttributeName : -1 * outlineWidth,
            ] as [String : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}

