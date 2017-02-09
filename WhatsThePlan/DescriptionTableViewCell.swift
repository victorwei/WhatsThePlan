//
//  DescriptionTableViewCell.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/5/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {


    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
