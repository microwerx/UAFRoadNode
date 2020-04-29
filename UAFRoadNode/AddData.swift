//
//  AddData.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski and Nami Kim on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit



class AddData: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var attributes_info = [Int: [String: String]]()
    var attribute_ids = Array<Int>()
    var attribute_names = Array<String>()
    var layer = String()
    
    var add_data_attributes = [Int: [String: Any]]()
    
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
    
    func getDateTime()-> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format.string(from: date)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //layer = DBManager.shared.getLayerName(node_id: selected_node)
        //attributes_info = DBManager.shared.getLayerAttributes(layer_name: layer)
        //buildAttrLists()
        //print(attributes)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layer = DBManager.shared.getLayerName(node_id: selected_node)
        attributes_info = DBManager.shared.getLayerAttributes(layer_name: layer)
        buildAttrLists()
        print(attributes_info)
        
    }
    
    
    @IBAction func submit(_ sender: Any) {
        print(add_data_attributes)
        for attr in attribute_ids {
            add_data_attributes[attr]?[DBManager.shared.field_data_dateTimeAdded] = getDateTime()
        }
        DBManager.shared.addDataPoint(attributes: add_data_attributes)
        
        let confirmMessage = UIAlertController(title: "Confirm", message: "You have successfully added a new node data.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
        })
        
        confirmMessage.addAction(ok)
        self.present(confirmMessage, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attribute_names.count
    }
    
    var cells = [Int: String]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! addDataTableViewCell
        // look at addDataTableViewCell.swift file to see UILabel/Text Field names
        let value_type_info = getValueTypeInfo(attr_id: attribute_ids[indexPath.row])
        let default_text = "\(value_type_info["value_type"] ?? ""): \(value_type_info["data_type"] ?? "")"
        cell.textLabel?.text = attribute_names[indexPath.row]
        cell.addDataTextField?.delegate = self
        cell.addDataTextField?.text = ""
        cell.addDataTextField?.placeholder = default_text
        cell.addDataTextField?.autocorrectionType = UITextAutocorrectionType.no
        cell.addDataTextField?.autocapitalizationType = UITextAutocapitalizationType.none
        cell.addDataTextField?.adjustsFontSizeToFitWidth = true;
        cell.addDataTextField.tag = attribute_ids[indexPath.row]
        let table_index = indexPath.row
        print(table_index)
        let text = cell.addDataTextField.tag
        print(text)
        cells[indexPath.row] = cell.addDataTextField?.text
        return cell
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let attr_id = textField.tag
        let text_input = textField.text ?? ""
        let data_value_info = getValueTypeInfo(attr_id: attr_id )
        let data_type = data_value_info["data_type"]
        //let value_type = getValueTypeInfo(attr_id: attr_id)["value_type"]
        
        var attributes = [String: Any]()
        
        var int_value = Int()
        var real_value = Double()
        var numeric_value = Double()
        var text_value = String()
        //var blob_value = "" // TODO : make entering BLOB data an option
        
        if data_type == "REAL" {
            real_value = Double(text_input) ?? -1.0
        }
        else if data_type == "NUMERIC" {
            numeric_value = Double(text_input) ?? -1.0
        }
        else if data_type == "INTEGER" {
            int_value = Int(text_input) ?? -1
        }
        else if data_type == "TEXT" {
            text_value = text_input
        }
        else{
            // TODO : Do something here when adding BLOB data
        }
        
        attributes[DBManager.shared.field_data_attrID] = attr_id
        attributes[DBManager.shared.field_data_nodeID] = selected_node
        //attributes[DBManager.shared.field_data_dateTimeAdded] = getDateTime()
        attributes[DBManager.shared.field_data_integerValue] = int_value
        attributes[DBManager.shared.field_data_real_value] = real_value
        attributes[DBManager.shared.field_data_numeric_value] = numeric_value
        attributes[DBManager.shared.field_data_textValue] = text_value
        add_data_attributes[attr_id ] = attributes
        // TODO: add BLOB data value
        print(textField.tag)
        print(textField.text ?? "")
        
    }
    
    
    //delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

