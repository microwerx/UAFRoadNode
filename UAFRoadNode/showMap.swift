//
//  showMap.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 2/24/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class showMap: UIViewController, GMSMapViewDelegate {
    var mapView: GMSMapView?

    @IBOutlet weak var showMap: UIView!
    override func loadView() {
        super.viewDidLoad()

        // Create a GMSCameraPosition that tells the map to display the
        // coordinate 64.855793, -147.833746
        let camera = GMSCameraPosition.camera(withLatitude: 64.855793, longitude: -147.833746, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        //view = mapView
        self.mapView?.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 64.855793, longitude:-147.833746)
        marker.title = "UAF"
        marker.snippet = "MarkerExample"
        marker.map = mapView
        marker.isDraggable = false //users cannot move the node
  }

}
