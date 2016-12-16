//
//  CustomSearchBar.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/9/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    
    var preferredFont: UIFont!
    var preferredColor: UIColor!
    
    init(frame: CGRect, font: UIFont, color: UIColor) {
        super.init(frame: frame)
        self.frame = frame
        self.preferredFont = font
        self.preferredColor = color
        
        searchBarStyle = .prominent
        isTranslucent = false
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    
    func indexOfSearchFieldInSubviews() -> Int! {
        
        var index: Int!
        let searchBarView = subviews[0]
        
        for i in 0..<searchBarView.subviews.count {
            if searchBarView.subviews[index].isKind(of: UITextField.self){
                index = i
                break
            }
        }

        return index
        
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRect(x: 5.0, y: 5.0, width: frame.size.width, height: frame.size.height)
            //CGRect(5.0, 5.0, frame.size.width - 10.0, frame.size.height - 10.0)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        
        let startPoint = CGPoint(x: 0.0, y: frame.size.height)  //CGPointMake(0.0, frame.size.height)
        let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)   //CGPointMake(frame.size.width, frame.size.height)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = preferredColor.cgColor
        shapeLayer.lineWidth = 2.5
        
        layer.addSublayer(shapeLayer)
        
        super.draw(rect)
    }
    
    
    
    
    
    
    
}
