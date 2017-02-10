//
//  UserImgTableViewCell.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 2/7/17.
//  Copyright © 2017 victorW. All rights reserved.
//

import UIKit

class UserImgTableViewCell: UITableViewCell {

    @IBOutlet weak var userImgView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func roundUserImg() {
        
        userImgView.layer.cornerRadius = userImgView.frame.width / 2
        userImgView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
