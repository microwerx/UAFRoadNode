//
//  showMap.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski and Nami Kim.
//  Copyright © 2020 UAFRoadNode. All rights reserved.

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces


//let colors = ["black", "blue", "brown", "cyan", "darkGray", "gray", "green", "lightGray", "magenta", "red", "white", "yellow"]
let colors = [UIColor.black, UIColor.blue, UIColor.brown, UIColor.cyan, UIColor.darkGray, UIColor.green, UIColor.lightGray, UIColor.magenta, UIColor.red, UIColor.white, UIColor.yellow]
//var layer_colors = [String: String]()
var layer_colors = [String: UIColor]()

var long_press_coords = CLLocationCoordinate2D()


class showMap: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var tap_coords = CLLocationCoordinate2D()
    
    var limit_longpress = false
    
    var longPressRecognizer = UILongPressGestureRecognizer()
    
    var nodes_on_display = Array<GMSMarker>()
    
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if !limit_longpress {
            print("LONG PRESS")
            limit_longpress = true
            performSegue(withIdentifier: "NameNodeSegue", sender: sender)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        limit_longpress = false
        assignLayerColors()
        print(layer_colors)
        makeNodes()
        for node in nodes_on_display {
            node.map = mapView
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // GOOGLE MAPS SDK: COMPASS
        mapView.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self,
        action: #selector(self.longPress))
        longPressRecognizer.minimumPressDuration = 0.75
        longPressRecognizer.delegate = self
        mapView.addGestureRecognizer(longPressRecognizer)
        
        //Default View = Alaska
        let cord2D = CLLocationCoordinate2D(latitude: 65.905217, longitude: -152.047295)
        
        self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 4.5)
        self.mapView.delegate = self
        //assignLayerColors()
        //displayNodes()
        //for node in no
        
        //let position = CLLocationCoordinate2D(latitude: 65.905217, longitude: -152.047295)
        //let marker = GMSMarker(position: position)
        //marker.title = "Hello World"
        //marker.icon = GMSMarker.markerImage(with: UIColor.green)
        //marker.map = mapView
    }
    
  //  func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
  //      let marker = GMSMarker(position: coordinate)
  //      marker.title = "Found You!"
  //      marker.map = mapView
  //  }
    
    
    func assignLayerColors() {
        var color_rounds = colors
        for layer in DBManager.shared.layersToDisplay() {
            if layer_colors[layer] == nil {
                if color_rounds.count == 0 {
                    color_rounds = colors
                }
                //let color = color_rounds.randomElement() ?? ""
                let color = color_rounds.randomElement() ?? UIColor.cyan
                color_rounds.remove(at: color_rounds.firstIndex(of: color) ?? -1)
                layer_colors[layer] = color
            }
        }
    }
    
    func makeNodes() {
        let nodes_to_display = DBManager.shared.nodes_to_display()
        for node in nodes_on_display {
            node.map = nil
        }
        nodes_on_display = Array<GMSMarker>()
        for node_id in nodes_to_display {
            let layer_name = DBManager.shared.getLayerName(node_id: node_id)
            print(layer_name)
            print(layer_colors[layer_name]!)
            //let color = UIColor(named: layer_colors[layer_name]!)
            let color = layer_colors[layer_name]!
            
            let node_coord = DBManager.shared.getNodeCoord(node_id: node_id)
            var position = CLLocationCoordinate2D()
            position.latitude = node_coord["latitude"] ?? -1.0
            position.longitude = node_coord["longitude"] ?? -1.0
            
            let marker = GMSMarker(position: position)
            //marker.title = "Hello World"
            marker.icon = GMSMarker.markerImage(with: color)
            nodes_on_display.append(marker)
        }
    }
    
    //func placeNodes() {
    //    txtSearch.resignFirstResponder()
    //    let acController = GMSAutocompleteViewController()
    //    acController.delegate = self
    //    present(acController, animated: true, completion: nil)
   // }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        tap_coords = coordinate
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        long_press_coords = coordinate
        print("You longpressed at \(coordinate.latitude), \(coordinate.longitude)")
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
        self.mapView.delegate = self

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController : UIGestureRecognizerDelegate
{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

extension showMap : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("Clicked on marker")
        showAlert(title: "Node DELETE Alert", message: "You sure you want to delete this node?", handlerOK: { action in marker.map=nil }, handlerCancel: { actionCancel in print("Action cancel")
        })
    }
}


// Code from the Homepage we got rid of
// will be useful for getting the lat/long info. 

//class ViewController: UIViewController {
//
//
//    let locationManager = CLLocationManager()
//
//    @IBOutlet weak var lblLocation: UILabel!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//
//        getCurrentLocation()
//    }
//
//    func getCurrentLocation() {
//        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//}
//
//extension ViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
//    }
//}
