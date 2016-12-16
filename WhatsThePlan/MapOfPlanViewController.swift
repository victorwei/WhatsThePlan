//
//  MapOfPlanViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/8/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GoogleMaps

class MapOfPlanViewController: UIViewController {

    
    @IBOutlet weak var googleContainerView: UIView!
    
    var googleMapView: GMSMapView!
    var plan: Plan!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        
        googleMapView = GMSMapView(frame: googleContainerView.frame)
        let camera = GMSCameraPosition.camera(withLatitude: City.sharedInstance.latitude, longitude: City.sharedInstance.longitude, zoom: 11.5)
        googleMapView.camera = camera
        
        self.view.addSubview(googleMapView)
        
        
    }

}
