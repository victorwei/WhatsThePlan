//
//  CreatePlanViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/5/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse

class CreatePlanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var plan = Plan()
    var textFieldIsEditting: Bool = false
    var locationController = LocationController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let descriptionCellNib = UINib(nibName: "DescriptionTableViewCell", bundle: nil)
        tableView.register(descriptionCellNib, forCellReuseIdentifier: "descriptionCell")
        
        let planCellNib = UINib(nibName: "PlanTableViewCell", bundle: nil)
        tableView.register(planCellNib, forCellReuseIdentifier: "planCell")
        
        let locationMapCellNib = UINib(nibName: "LocationMapTableViewCell", bundle: nil)
        tableView.register(locationMapCellNib, forCellReuseIdentifier: "locationMapCell")
        
        let sectionHeaderNib = UINib(nibName: "SectionTableViewCell", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "sectionHeaderCell")
        
    }
    
    
    
    // MARK: - IBAction
    
    @IBAction func savePlan(_ sender: Any) {
        
        //check if textField is still being editted.  If so, resign the first responder for it
        if textFieldIsEditting {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! DescriptionTableViewCell
            cell.textField.resignFirstResponder()
        }
        
        guard plan.title != nil,
            plan.plan != nil,
            plan.locationIDs != nil else {
                //Display alert that all fields have not been filled out yet
                return
        }
        
        saveData()
        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - Save Function to Database
    
    func saveData() {
        
        Database.sharedInstance.savePlan(shortDescription: plan.title!, plan: plan.plan!, city: City.sharedInstance.cityName, locations: plan.locationIDs!) { [unowned self] (success) in
            
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    

}






// MARK: - WritePlanProtocol

extension CreatePlanViewController: WritePlanProtocol {
    
    func getPlan(thePlan: String) {
        plan.plan = thePlan
        tableView.reloadData()
    }
}


extension CreatePlanViewController: GetLocationsProtocol {
    
    func getLocations(markers: [GMSMarker], locations: [String]) {
        plan.locationMarkers = markers
        plan.locationIDs = locations
        tableView.reloadData()
    }
}


// MARK: - TableView DataSource/Delegate

extension CreatePlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return plan.sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            guard plan.plan != nil else {
                return 1
            }
            return 2
        case 2:
            guard plan.locationMarkers != nil else {
                return 1
            }
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeaderCell", for: indexPath) as! SectionTableViewCell
            if indexPath.section == 0 {
                cell.label.text = plan.sectionHeaders[0]
                cell.selectionStyle = .none
                cell.accessoryType = .none
                
            } else if indexPath.section == 1 {
                cell.label.text = plan.sectionHeaders[1]
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.label.text = plan.sectionHeaders[2]
                cell.accessoryType = .disclosureIndicator
            }
            return cell
            
            
        case 1:
            
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionTableViewCell
                cell.textField.delegate = self
                cell.selectionStyle = .none
                
                return cell
                
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as! PlanTableViewCell
                cell.label.text = plan.plan
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "locationMapCell", for: indexPath) as! LocationMapTableViewCell
                cell.setup(markers: plan.locationMarkers!)
                return cell
            }
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! DescriptionTableViewCell
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let planIndex = IndexPath(row: 0, section: 1)
        let mapIndex = IndexPath(row: 0, section: 2)
        
        if indexPath == planIndex {
          
            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WritePlanViewController") as! WritePlanViewController
            destinationVC.delegate = self
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        } else if indexPath == mapIndex {
            
            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            let destinationNC = UINavigationController(rootViewController: destinationVC)
            destinationVC.delegate = self
            present(destinationNC, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}



// MARK: - UITextField Delegate methods

extension CreatePlanViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldIsEditting = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        plan.title = textField.text
        textFieldIsEditting = false
    }
    
    
}



