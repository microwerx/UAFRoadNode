//
//  myMapScreen.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 2/24/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class myMapScreen: UIViewController, CLLocationManagerDelegate {
    let locationManager=CLLocationManager()
    
    @IBOutlet weak var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate=self
        self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManager.stopUpdatingLocation()
    }
    
    func showCurrentLocationOnMap() {
        
        let camera=GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.latitude)!, zoom: 14)
        
        let mapView=GMSMapView.map(withFrame: CGRect(x: 0,y: 0,width: self.myView.frame.size.width,height: self.myView.frame.size.height), camera: camera)
        
        mapView.settings.myLocationButton=true
        mapView.isMyLocationEnabled=true
        
        let marker=GMSMarker()
        //marker.position=camera.target
        //marker.snippet="Current location"
        marker.appearAnimation=GMSMarkerAnimation.pop
        marker.map=mapView
        self.myView.addSubview(mapView)
    }
}
