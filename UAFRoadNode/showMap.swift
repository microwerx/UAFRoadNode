//
//  showMap.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 2/24/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

class showMap: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBAction func locationTapped(_ sender: Any) {
        gotoPlaces()
    }
    
    @IBAction func addNode(_ sender: Any) {
        gotoPlaces()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // GOOGLE MAPS SDK: COMPASS
        mapView.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        // GOOGLE MAPS SDK: ALLOW TRAFFIC INFORMATION 
        mapView.isTrafficEnabled = true
    }
    
    func gotoPlaces() {
        txtSearch.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, handlerOK:((UIAlertAction) -> Void)?, handlerCancel:((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: . alert)
        let action = UIAlertAction(title: "OK", style: .destructive, handler: handlerOK)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: handlerCancel)
        alert.addAction(action)
        alert.addAction(actionCancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    let locationManager = CLLocationManager()
    
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


extension showMap: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
        
    }
}

extension showMap: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        
        self.txtSearch.text = place.name
        
        let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        
        var markerArray = [GMSMarker]()
        let marker = GMSMarker()
        marker.position =  cord2D
        marker.title = place.name
        marker.snippet = "node"
        
        let markerImage = UIImage(named: "node_pin")!
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
        marker.map = self.mapView
        markerArray.append(marker)
        
        self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
        self.mapView.delegate = self

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension showMap : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("Clicked on marker")
        showAlert(title: "Node DELETE Alert", message: "You sure you want to delete this node?", handlerOK: { action in marker.map=nil }, handlerCancel: { actionCancel in print("Action cancel")
        })
    }
}

