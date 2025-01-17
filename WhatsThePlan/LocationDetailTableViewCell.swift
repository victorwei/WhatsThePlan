//
//  LocationDetailTableViewCell.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/12/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class LocationDetailTableViewCell: UITableViewCell {


    @IBOutlet weak var iconImg: UIImageView!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoTextView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
