//
//  NodeMenu.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski  on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class NodeMenu: UIViewController {

    @IBOutlet weak var node_type_label: UILabel!
    
    @IBOutlet weak var node_name_label: UILabel!
    
    @IBAction func view_node_data(_ sender: Any) {
    }
    
    @IBAction func add_node_data(_ sender: Any) {
    }
    
    @IBAction func delete_node(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        node_name_label.text = DBManager.shared.getLayerName(node_id: selected_node)
        node_type_label.text = DBManager.shared.getNodeName(node_id: selected_node)
        

        // Do any additional setup after loading the view.
    }
}
