//
//  NodeMenu.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski  on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class NodeMenu: UIViewController {

    @IBOutlet weak var lat_label: UILabel!
    @IBOutlet weak var long_label: UILabel!
    @IBOutlet weak var node_type_label: UILabel!
    @IBOutlet weak var node_name_label: UILabel!
    
    @IBAction func add_node_data(_ sender: Any) {
    }
    
    @IBAction func delete_node(_ sender: Any) {
        DBManager.shared.deleteNode(node_id: selected_node)
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        node_name_label.text = DBManager.shared.getLayerName(node_id: selected_node)
        node_type_label.text = DBManager.shared.getNodeName(node_id: selected_node)
        let coord = DBManager.shared.getNodeCoord(node_id: selected_node)
        lat_label.text = String(format:"%f", coord["latitude"] ?? -1.0)
        long_label.text = String(format:"%f", coord["longitude"] ?? -1.0)

        // Do any additional setup after loading the view.
    }
}
