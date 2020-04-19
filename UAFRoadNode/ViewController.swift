//
//  ViewController.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 2/10/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.



import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var lblLocation: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getCurrentLocation()
    }
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
    }
}





