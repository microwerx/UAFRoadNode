//
//  newLayerTypeViewController.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/18/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class newLayerTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var valueTypeNames: Array<String> = DBManager.shared.selectValueTypeNames()
    
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
            }
            else {
                // TODO: display an on screen warning
                print("Error: layer name already exists.")
            }
                
            // reset the attribute dictionary
            attribute_query_dicts = Array<[String: Any]>()
            layer_name.text = ""
        }
        else {

            // TODO: [display an on screen warning]
            print("Error: Attempted to add a layer type with no attributes")

        }
        
    }
    
    
    @IBAction func addAttribute(_ sender: UIButton) {
        let attributes_attr = ["name": attribute_name.text!, "layer_name": "", "value_type_id": DBManager.shared.valueTypeIDFromName(name: selectedValueType)] as [String : Any]?
        attribute_query_dicts.append(attributes_attr ?? ["": -1])
        attribute_name.text = ""
        print("adding attirbutes to list")
        print(attributes_attr as Any)
        attribute_count += 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedValueType = valueTypeNames[indexPath.row]
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
        return valueTypeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Value Type", for: indexPath)
        
        
        cell.textLabel?.text = valueTypeNames[indexPath.row]
        
        return cell
    }

}
