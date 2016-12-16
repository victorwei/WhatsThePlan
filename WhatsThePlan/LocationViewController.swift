//
//  LocationViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/10/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var sections: [String]!
    var locationInfo: LocationInfo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setup() {
        
        sections = ["Image", "Information", "Map"]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let imageNib = UINib(nibName: "LocationPhotoTableViewCell", bundle: nil)
        tableView.register(imageNib, forCellReuseIdentifier: "photoCell")
        
        let detailNib = UINib(nibName: "LocationDetailTableViewCell", bundle: nil)
        tableView.register(detailNib, forCellReuseIdentifier: "detailCell")
        
        let locationMapCellNib = UINib(nibName: "LocationMapTableViewCell", bundle: nil)
        tableView.register(locationMapCellNib, forCellReuseIdentifier: "locationMapCell")
        
        locationInfo.fillOutLocationValues()
        locationInfo.createMarker()
    }
    
    
    
    
}



extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return locationInfo.locationTypes.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! LocationPhotoTableViewCell
            
            if let photo = locationInfo.photo {
                cell.photoImg.image = UIImage(data: photo)
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! LocationDetailTableViewCell
            cell.infoLabel.text = locationInfo.locationValues[indexPath.row]
            
            if indexPath.row == 0 {
                //cell.detailLabel.font = cell.detailLabel.font.fontWithSize(20)
                cell.infoLabel.font = UIFont.boldSystemFont(ofSize: 20)
            }
            //set whihc info icon to display based on which information is displayed
            switch locationInfo.locationTypes[indexPath.row] {
            case "address":
                cell.iconImg.image = UIImage(named: "address")
            case "website":
                cell.iconImg.image = UIImage(named: "website")
            case "phonenumber":
                cell.iconImg.image = UIImage(named: "phone")
            case "price":
                cell.iconImg.image = UIImage(named: "price")
            case "rating":
                cell.iconImg.image = UIImage(named: "rating")
            case "availability":
                cell.iconImg.image = UIImage(named: "availability")
            default:
                cell.iconImg.isHidden = true
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationMapCell", for: indexPath) as! LocationMapTableViewCell
            
            cell.locationViewSetup(marker: locationInfo.marker!, latitude: locationInfo.latitude!, longitude: locationInfo.longitude!)
            
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            return cell
        }
        
      
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            
        case 0:
            return self.view.frame.height/4
            
        case 1:
            if indexPath.row == 0 {
                return 20
            } else {
                return 10
            }
        case 2:
            return self.view.frame.width
        default:
            return 10
         
        }
    }
    
    
}
