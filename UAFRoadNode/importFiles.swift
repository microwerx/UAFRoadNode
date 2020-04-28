//
//  importFiles.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski on 4/5/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit
import MobileCoreServices
import GoogleMaps
import GoogleMapsUtils

class importFiles: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // TODO: [Write import KML fucntion]
    func importKML(DBManager: Any, String: Any) {}
    
    // TODO: [Wrtie import CSV function]
    func importCSV(DBManager: Any, String: Any) {}
}


// Note that this commented code displays a KML file on google maps. Might be useful.
// A user can choose a KML file from their Files directory on their phone

//class importFiles: UIViewController {
//
//    private var mapView: GMSMapView!
//    private var renderer: GMUGeometryRenderer!
//    private var kmlParser: GMUKMLParser!
//    private var geoJsonParser: GMUGeoJSONParser!
//
//    @IBAction func importData(_ sender: Any) {
//        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
//        documentPicker.delegate = self
//        documentPicker.allowsMultipleSelection = false;
//        present(documentPicker, animated: true, completion: nil)
//    }
//}
//
//extension importFiles: UIDocumentPickerDelegate {
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let selectedFileURL = urls.first else {
//            return
//        }
//
//        // default camera at UAF, but the user should have an idea of the general location of the kml file he/she is importing
//        let camera = GMSCameraPosition.camera(withLatitude: 64.856778, longitude: -147.834057, zoom: 0)
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        self.view = mapView
//
//        kmlParser = GMUKMLParser(url: selectedFileURL)
//        kmlParser.parse()
//
//        renderer = GMUGeometryRenderer(map: mapView,
//                                       geometries: kmlParser.placemarks,
//                                       styles: kmlParser.styles,
//                                       styleMaps: kmlParser.styleMaps)
//
//        renderer.render()
//
//    }
//}
