//
//  CityResultsTableViewCell.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/14/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class CityResultsTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
