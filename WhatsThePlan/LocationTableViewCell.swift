//
//  LocationTableViewCell.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/8/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var rating1: UIImageView!
    @IBOutlet weak var rating2: UIImageView!
    @IBOutlet weak var rating3: UIImageView!
    @IBOutlet weak var rating4: UIImageView!
    @IBOutlet weak var rating5: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var baseRating: Int!
    var ratingRemainder: Float!
    var rating: Float!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImages() {
        
        setRating()
        
        switch baseRating {
        case 1:
            rating1.image = UIImage(named: "full-star")
            if ratingRemainder > 0.25 && ratingRemainder < 0.75{
                rating2.image = UIImage(named: "half-star")
            } else if ratingRemainder >= 0.75 {
                rating2.image = UIImage(named: "full-star")
            }
            
        case 2:
            rating1.image = UIImage(named: "full-star")
            rating2.image = UIImage(named: "full-star")
            if ratingRemainder > 0.25 && ratingRemainder < 0.75{
                rating3.image = UIImage(named: "half-star")
            } else if ratingRemainder >= 0.75 {
                rating3.image = UIImage(named: "full-star")
            }
            
        case 3:
            rating1.image = UIImage(named: "full-star")
            rating2.image = UIImage(named: "full-star")
            rating3.image = UIImage(named: "full-star")
            if ratingRemainder > 0.25 && ratingRemainder < 0.75{
                rating4.image = UIImage(named: "half-star")
            } else if ratingRemainder >= 0.75 {
                rating4.image = UIImage(named: "full-star")
            }
            
        case 4:
            rating1.image = UIImage(named: "full-star")
            rating2.image = UIImage(named: "full-star")
            rating3.image = UIImage(named: "full-star")
            rating4.image = UIImage(named: "full-star")
            if ratingRemainder > 0.25 && ratingRemainder < 0.75{
                rating5.image = UIImage(named: "half-star")
            } else if ratingRemainder >= 0.75 {
                rating5.image = UIImage(named: "full-star")
            }
            
        case 5:
            rating1.image = UIImage(named: "full-star")
            rating2.image = UIImage(named: "full-star")
            rating3.image = UIImage(named: "full-star")
            rating4.image = UIImage(named: "full-star")
            rating5.image = UIImage(named: "full-star")
            
        default:
            break
        }
    }
    
    func setRating () {
        
        baseRating = Int(rating)
        ratingRemainder = rating.truncatingRemainder(dividingBy: 1)
    }
    
}
