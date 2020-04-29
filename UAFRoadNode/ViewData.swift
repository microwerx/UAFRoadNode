//
//  ViewData.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski  on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class ViewData: UIViewController {
    
    var attributes_info = [Int: [String: String]]()
    var attribute_ids = Array<Int>()
    var attribute_names = Array<String>()
    var layer = String()
    
    func buildAttrLists() {
        for attr_info in attributes_info {
            let attr_id = attr_info.key
            attribute_ids.append(attr_id)
            attribute_names.append(attributes_info[attr_id]?["attr_name"] ?? "")
        }
    }

    func getValueTypeInfo(attr_id: Int) -> [String: String] {
        var info = [String: String]()
        for (k, v) in attributes_info[attr_id] ?? ["":""] {
            if k != "attr_name" {
                info["value_type"] = k
                info["data_type"] = v
            }
        }
        return info
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layer = DBManager.shared.getLayerName(node_id: selected_node)
        attributes_info = DBManager.shared.getLayerAttributes(layer_name: layer)
        buildAttrLists()
        let df = "wefwf"
        print(df)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewData: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return attribute_names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! viewDataTableViewCell
        let attr_id = attribute_ids[indexPath.row]
        let data_value_info = getValueTypeInfo(attr_id: attr_id )
        let data_type = data_value_info["data_type"] ?? ""
        // attr_id: Int, data_type: String, node_id: Int, date_time: String
        let attr_value = DBManager.shared.getDataPointValue(attr_id: attr_id, data_type: data_type, node_id: selected_node, date_time: selectedDateTime)
        
        cell.attributeType.text = attribute_names[indexPath.row] // fill in your value for column 1 (e.g. from an array)
        cell.attributeValue.text = attr_value // fill in your value for column 2
        
        return cell
    }
    
}
