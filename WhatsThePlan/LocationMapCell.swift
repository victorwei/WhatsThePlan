//
//  LocationMapCell.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 1/25/17.
//  Copyright © 2017 victorW. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationMapCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var googleContainerView: UIView!
    
    
    var googleMapView: GMSMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func initialSetup() {
        
        googleMapView = GMSMapView(frame: googleContainerView.frame)
        let camera = GMSCameraPosition.camera(withLatitude: City.sharedInstance.latitude, longitude: City.sharedInstance.longitude, zoom: 11.5)
        googleMapView.camera = camera
        
        self.addSubview(googleMapView)
        
    }
    
    func setup(markers: [GMSMarker]) {
        
        let googleMapView = GMSMapView(frame: googleContainerView.frame)
        let camera = GMSCameraPosition.camera(withLatitude: City.sharedInstance.latitude, longitude: City.sharedInstance.longitude, zoom: 11.5)
        googleMapView.camera = camera
        googleMapView.autoresizesSubviews = true
        
        self.addSubview(googleMapView)
        
        //Add markers to the map
        for marker in markers {
            marker.map = googleMapView
        }
        
        
    }
    
    
    func locationViewSetup (marker: GMSMarker, latitude: Double, longitude: Double) {
        
        let googleMapView = GMSMapView(frame: googleContainerView.frame)
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 11.5)
        googleMapView.camera = camera
        self.addSubview(googleMapView)
        
        marker.map = googleMapView
        
    }
    
    
    
}
