//
//  UserTableViewCell.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/8/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Initialization code
    }

    func setImage() {
        userImg.layer.cornerRadius = userImg.frame.width / 2
        userImg.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
