//
//  PlanViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/8/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    
    var sectionHeaders = ["User", "Title", "Plan"]
    
    var plan: Plan!
    var user: [String: Any]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setLocationInformation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        
        tableView.delegate = self
        tableView.dataSource = self
    
        let userNib = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(userNib, forCellReuseIdentifier: "userCell")
        
        let titleNib = UINib(nibName: "TitleTableViewCell", bundle: nil)
        tableView.register(titleNib, forCellReuseIdentifier: "titleCell")
        
        let planNib = UINib(nibName: "PlanTableViewCell", bundle: nil)
        tableView.register(planNib, forCellReuseIdentifier: "planCell")
        
        let locationNib = UINib(nibName: "LocationTableViewCell", bundle: nil)
        tableView.register(locationNib, forCellReuseIdentifier: "locationCell")
        
        
        let sectionNib = UINib(nibName: "SectionHeaderTableViewCell", bundle: nil)
        tableView.register(sectionNib, forCellReuseIdentifier: "headerCell")
        
    }
    
    
    
    
    func setLocationInformation () {
        
        
        Database.sharedInstance.getLocationsForPlan(pfObject: plan.locationObject!) { [unowned self] (success, locationIds) in
            if success {
                
                self.plan.locationIDs = locationIds
                
                self.plan.getLocationInfo { (result) in
                    if result {
                        if self.plan.locations != nil {
                            self.sectionHeaders.append("Points of Interests")
                        } else {
                            self.sectionHeaders.append("Food/Drinks")
                        }
                        
                        if self.plan.foodDrinks != nil {
                            self.sectionHeaders.append("Food/Drinks")
                        }
                        
                        self.tableView.reloadData()
                    }
                    self.tableView.reloadData()
                }
                
            }
        }

        Database.sharedInstance.getSpecificUserInfo(userId: plan.userId!) { (success, userData) in
            if success {
                self.user = userData
                self.tableView.reloadData()
            }
        }
    }
    

    @IBAction func mapViewOfPlan(_ sender: Any) {
        
        let destinationVC = MapOfPlanViewController(nibName: "MapOfPlanViewController", bundle: nil)
        destinationVC.plan = plan
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
        
        
    }

}








// MARK: - tableView Delegate/DataSource

extension PlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        switch section {
            
        case 3:
        
            if plan.locations?.count != nil {
                return (plan.locations?.count)!
            } else {
                return (plan.foodDrinks?.count)!
            }
            
        case 4:
            return (plan.foodDrinks?.count)!
        default:
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
            
            if user == nil {
                return cell
            }
            
            let userPhoto = user["photo"] as! Data
            let first_name = user["firstName"] as! String
            let last_name = user["lastName"] as! String
            let name = first_name + " " + String(describing: last_name.characters.first!)

            cell.namelabel.text = name
            cell.userImg.image = UIImage(data: userPhoto)
            cell.setImage()
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleTableViewCell
            cell.titleLabel.text = plan.title
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as! PlanTableViewCell
            cell.label.text = plan.plan
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
            
            var foodCategory = true
            if sectionHeaders[indexPath.section] == "Points of Interests" {
                foodCategory = false
            }
            
            return fillOutLocationCells(tableCell: cell, index: indexPath.row, food: foodCategory)
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
            
            return fillOutLocationCells(tableCell: cell, index: indexPath.row, food: true)
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            return cell
        }
    }
    
    
    
    
    //Helper function to fill out LocationTableViewCells
  
    func fillOutLocationCells(tableCell: UITableViewCell, index: Int, food: Bool) -> LocationTableViewCell {
        
        let cell = tableCell as! LocationTableViewCell
        
        if !food {
            
            if let photo = plan.locations?[index].photo {
                cell.locationImg.image = UIImage(data: photo)
            }
            
            if let name = plan.locations?[index].name {
                cell.titleLabel.text = name
            }
            
            if let address = plan.locations?[index].address {
                cell.addressLabel.text = address.returnAddressWithoutStateCountry()
            }
            
            
            if let types = plan.locations?[index].types {
                
                if types.count != 0 {
                    
                    var typetext = ""
                    for type in types {
                        typetext = typetext + type + ", "
                    }
                    let typesCount = typetext.characters.count
                    let stringCount = typesCount - 2
                    
                    let index = typetext.index(typetext.startIndex, offsetBy: stringCount)
                    typetext = typetext.substring(to: index)
                    
                    cell.typesLabel.text = typetext
                } else {
                    cell.typesLabel.text = ""
                }
                
            }
            
            
            if let rating = plan.locations?[index].rating {
                cell.rating = rating
                cell.setImages()
            }
            
        } else {
            
            if let photo = plan.foodDrinks?[index].photo {
                cell.locationImg.image = UIImage(data: photo)
            }
            
            if let name = plan.foodDrinks?[index].name {
                cell.titleLabel.text = name
            }
            
            if let address = plan.foodDrinks?[index].address {
                cell.addressLabel.text = address.returnAddressWithoutStateCountry()
            }
            
            
            if let types = plan.foodDrinks?[index].types {
                var typetext = ""
                for type in types {
                    typetext = typetext + type + ", "
                }
                let typesCount = typetext.characters.count
                let stringCount = typesCount - 2
                
                let index = typetext.index(typetext.startIndex, offsetBy: stringCount)
                typetext = typetext.substring(to: index)
                
                cell.typesLabel.text = typetext
            }
            
            
            if let rating = plan.foodDrinks?[index].rating {
                cell.rating = rating
                cell.setImages()
            }
            
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return 20
        case 2:
            return UITableViewAutomaticDimension
        default:
            return 80
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return UITableViewAutomaticDimension
        case 2:
            return UITableViewAutomaticDimension
        default:
            return 80
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        if section == 3 || section == 4 {
            
            let destinationVC = LocationViewController(nibName: "LocationViewController", bundle: nil)
            
            if section == 3 && sectionHeaders[3] == "Points of Interests" {
                destinationVC.locationInfo = plan.locations?[indexPath.row]
            } else {
                destinationVC.locationInfo = plan.foodDrinks?[indexPath.row]
            }
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SectionHeaderTableViewCell
        
        switch section {
        case 3:
            cell.sectionLabel.text = sectionHeaders[3]
            return cell
            
        case 4:
            cell.sectionLabel.text = sectionHeaders[4]
            return cell
        default:
            return nil
        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 20
        case 4:
            return 20
        default:
            return 0
        }
    }
}






extension String {
    
    
    func returnAddressWithoutStateCountry() -> String {
        
        //All addresses have the final part consistent.  For example, "1123 Address St., Fake Address, CA 90000, USA"
        //Get the substring that omits ', CA 90000, USA;, which shoudl stay constistent regardless of the address
        let string = self.characters.count
        let count = string - 15
        let stringIndex = self.index(self.startIndex, offsetBy: count)
        
        return self.substring(to: stringIndex)
       
    }
    
}
