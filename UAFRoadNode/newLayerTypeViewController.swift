//
//  newLayerTypeViewController.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski  on 4/18/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class newLayerTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var valueTypesInfo: [Int: String] = DBManager.shared.selectValueTypeNames()
    var valueType_ids = Array<Int>()
    var valueType_names = Array<String>()
    var selectedValueType = ""
    var attribute_count = 0
    
    var attribute_query_dicts = Array<[String: Any]>()
    
    @IBOutlet weak var layer_name: UITextField!
    
    @IBOutlet weak var valueType_tableView: UITableView!
    
    @IBOutlet weak var attribute_name: UITextField!
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func buildValueTypeLists() {
        for valueType_info in valueTypesInfo {
            let value_type_id = valueType_info.key
            valueType_ids.append(value_type_id)
            valueType_names.append(valueTypesInfo[value_type_id] ?? "")
        }
    }
    
    
    @IBAction func addNewLayerType(_ sender: UIButton) {
        let layer_attr = ["name": layer_name.text!, "creation_date": getDate(), "crypto": "test", "crypto_key": "test", "md5_hash": "test", "created_locally": 1, "on_display": 1] as [String : Any]
        
        if attribute_count > 0 {
            if DBManager.shared.isUnique_layerName(name: layer_name.text!) {
                DBManager.shared.addLayerType(attr: layer_attr)
                DBManager.shared.selectLayersQuery()
                
                for (i, _) in attribute_query_dicts.enumerated() {
                    attribute_query_dicts[i]["layer_name"] = layer_name.text!
                }
                for attr in attribute_query_dicts {
                    DBManager.shared.addAttribute(attr: attr)
                }
                DBManager.shared.selectAttributesQuery()
                let confirmMessage = UIAlertController(title: "Confirm", message: "You have successfully added a new layer.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
                })
                
                confirmMessage.addAction(ok)
                self.present(confirmMessage, animated: true, completion: nil)
            }
            else {
                let errorMessage = UIAlertController(title: "Error", message: "Layer name already exists.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
                })
                
                errorMessage.addAction(ok)
                self.present(errorMessage, animated: true, completion: nil)
                print("Error: layer name already exists.")
            }
            
            // reset the attribute dictionary
            attribute_query_dicts = Array<[String: Any]>()
            layer_name.text = ""
            assignLayerColors(hard_reset: true)
            
        }
        else {
            
            let errorMessage = UIAlertController(title: "Error", message: "Error: Attempted to add a layer type with no attributes", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
            })
            
            errorMessage.addAction(ok)
            self.present(errorMessage, animated: true, completion: nil)
            print("Error: Attempted to add a layer type with no attributes")
        }
        
    }
    
    
    @IBAction func addAttribute(_ sender: UIButton) {
        let attributes_attr = ["name": attribute_name.text!, "layer_name": "", "value_type_id": DBManager.shared.valueTypeIDFromName(name: selectedValueType)] as [String : Any]?
        
        if(layer_name.text != "") {
            if(attribute_name.text! != "") {
                attribute_query_dicts.append(attributes_attr ?? ["": -1])
                attribute_name.text = ""
                print("adding attirbutes to list")
                print(attributes_attr as Any)
                attribute_count += 1
                
                let confirmMessage = UIAlertController(title: "Confirm", message: "You have successfully added a new attribute.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
                })
                
                confirmMessage.addAction(ok)
                self.present(confirmMessage, animated: true, completion: nil)
            }
            
            if(attribute_name.text! == "") {
                let errorMessage = UIAlertController(title: "Error", message: "You need to enter an attribute name.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
                })
                
                errorMessage.addAction(ok)
                self.present(errorMessage, animated: true, completion: nil)
            }
        }
        if(layer_name.text == "") {
            let errorMessage = UIAlertController(title: "Error", message: "You need to assign a layer name first.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
            })
            
            errorMessage.addAction(ok)
            self.present(errorMessage, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedValueType = valueType_names[indexPath.row]
        print(selectedValueType)
    }
    
    
    func getDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        print(formattedDate)
        return(formattedDate)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildValueTypeLists()
        valueType_tableView.dataSource = self
        valueType_tableView.delegate = self
        layer_name.delegate = self
        attribute_name.delegate = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Navigation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueType_ids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Value Type", for: indexPath)
        let data_type = DBManager.shared.getDataTypeName(value_type_id: valueType_ids[indexPath.row])
        let cell_text = "\(valueType_names[indexPath.row]): \(data_type)"
        cell.textLabel?.text = cell_text
        
        return cell
    }
    
}
