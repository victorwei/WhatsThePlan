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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setup()
        addMarkers()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        
        googleMapView = GMSMapView(frame: googleContainerView.frame)
        let camera = GMSCameraPosition.camera(withLatitude: City.sharedInstance.latitude, longitude: City.sharedInstance.longitude, zoom: 11.5)
        googleMapView.camera = camera
        googleMapView.delegate = self
        
        self.view.addSubview(googleMapView)
        
        self.navigationItem.title = "Map of Plan"
        
        
    }
    
    
    func addMarkers() {
        
        plan.getLocationInfo { (success) in
            if success {
                self.plan.getMarkerInfo()
                
                
                guard let markerArray = plan.locationMarkers else {
                    return
                }
                
                for marker in markerArray {
                    marker.map = googleMapView
                }
                //for marker in plan.locationMarkers
                
            }
        }
        
    }
    
    

}


extension MapOfPlanViewController: GMSMapViewDelegate {
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let markers = plan.locationMarkers else {
            return
        }
        
        for index in 0..<markers.count {
            if markers[index] == marker {
                
                let destinationVC = LocationViewController(nibName: "LocationViewController", bundle: nil)
                destinationVC.locationInfo = plan.allLocations?[index]
                
                self.navigationController?.pushViewController(destinationVC, animated: true)
                break
            }
        }
    }
    
    
    
    
    
    
}
