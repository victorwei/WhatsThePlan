//
//  LocationMapTableViewCell.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/5/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationMapTableViewCell: UITableViewCell {

    @IBOutlet weak var googleMapContainerView: UIView!
    
    var googleMapView: GMSMapView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //initialSetup()
        
    }
    
    
    func initialSetup() {
        
        googleMapView = GMSMapView(frame: googleMapContainerView.frame)
        self.addSubview(googleMapView)
        
    }
    
    
    
    func setup(markers: [GMSMarker]) {
        
        let googleMapView = GMSMapView(frame: googleMapContainerView.frame)
        let camera = GMSCameraPosition.camera(withLatitude: City.sharedInstance.latitude, longitude: City.sharedInstance.longitude, zoom: 11.5)
        googleMapView.camera = camera
        
        self.addSubview(googleMapView)
        
        //Add markers to the map
        for marker in markers {
            marker.map = googleMapView
        }
        
        
    }
    
    
    func locationViewSetup (marker: GMSMarker, latitude: Double, longitude: Double) {
        
        let googleMapView = GMSMapView(frame: googleMapContainerView.frame)
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 11.5)
        googleMapView.camera = camera
        self.addSubview(googleMapView)
        
        marker.map = googleMapView
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
