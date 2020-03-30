//
//  showMap.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 2/24/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.

import UIKit
import GoogleMaps
import GooglePlaces

class showMap: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBAction func locationTapped(_ sender: Any) {
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
    }
    
    func gotoPlaces() {
        txtSearch.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
}

extension showMap: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
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

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }
}

