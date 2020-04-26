//
//  NameNode.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class NameNode: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
        let node_name = nameText.text!
        if node_name != "" {
            let node_attributes = [DBManager.shared.field_nodes_name: nameText.text!, DBManager.shared.field_nodes_lat: long_press_coords.latitude, DBManager.shared.field_nodes_long: long_press_coords.longitude, DBManager.shared.field_nodes_layerName: selectedNodeType] as [String : Any]
            DBManager.shared.addNode(attr: node_attributes)
        }
        else {
            //TODO : Handle user trying to add node with no assigned layer type
            print("ERROR: Cannot assign node with no layer type")
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
