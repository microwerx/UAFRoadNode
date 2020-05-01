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
        self.presentAlert(withTitle: "Node DELETE", message: "Are you sure you want to delete this node?", actions: [
            "Yes" : .default, "Cancel": .destructive] , completionHandler: {(action) in
                
                if (action.title == "Yes") {
                    DBManager.shared.deleteNode(node_id: selected_node)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }else if (action.title == "Cancel") {
                    print("tapped on Cancel")
                }
        })
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
        
        func presentAlert(withTitle title: String, message : String, actions : [String: UIAlertAction.Style], completionHandler: ((UIAlertAction) -> ())? = nil) {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            for action in actions {
                
                let action = UIAlertAction(title: action.key, style: action.value) { action in
                    
                    if completionHandler != nil {
                        completionHandler!(action)
                    }
                }
                
                alertController.addAction(action)
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
}
