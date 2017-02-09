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
        
        
//        let locationCellNib = UINib(nibName: "LocationMapCell", bundle: nil)
//        tableView.register(locationCellNib, forCellReuseIdentifier: "locationCell")
        
        self.title = "Create Plan"
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if plan.locationIDs == nil {
            return plan.sectionHeaders.count
        } else {
            return plan.sectionHeaders.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DescriptionTableViewCell
            cell.textField.delegate = self
            cell.selectionStyle = .none
            
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as! PlanTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.init(netHex: 0xF2F2F2)
            if plan.plan != nil {
                cell.label.text = plan.plan
            }
            return cell
            
            
        case 2:
            
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeaderCell", for: indexPath) as! SectionTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.init(netHex: 0xF2F2F2)
            
            
            return cell
            

            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationMapCell", for: indexPath) as! LocationMapTableViewCell
            
            cell.setup(markers: plan.locationMarkers!)
            
            return cell
            
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! DescriptionTableViewCell
            return cell
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let planIndex = IndexPath(row: 1, section: 0)
        let mapIndex = IndexPath(row: 2, section: 0)
        
        if indexPath == planIndex {
          
            //present WritePlanVC set delegate to get info back
            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WritePlanViewController") as! WritePlanViewController
            destinationVC.delegate = self
            
            
            // If there is an existing plan, replace the textview's text with existing plan.
            if let plantext = plan.plan {
                destinationVC.planText = plantext
            }
            
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        } else if indexPath == mapIndex {
            
            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            let destinationNC = UINavigationController(rootViewController: destinationVC)
            destinationVC.delegate = self
            present(destinationNC, animated: true, completion: nil)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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



