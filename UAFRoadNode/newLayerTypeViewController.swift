//
//  newLayerTypeViewController.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/18/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class newLayerTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var valueTypeNames: Array<String> = DBManager.shared.selectValueTypeNames()
    
    var selectedValueType = ""
    
    var attribute_query_dicts = Array<[String: Any]>()

    @IBOutlet weak var layer_name: UITextField!
    
    @IBOutlet weak var valueType_tableView: UITableView!
    
    @IBOutlet weak var attribute_name: UITextField!
    
    
    
    @IBAction func addNewLayerType(_ sender: UIButton) {
        let layer_attr = ["name": layer_name.text!, "creation_date": getDate(), "crypto": "test", "crypto_key": "test", "md5_hash": "test"]
        
        DBManager.shared.addLayerType(attr: layer_attr)
        DBManager.shared.selectLayersQuery()
        
        for attr in attribute_query_dicts {
            DBManager.shared.addAttribute(attr: attr)
        }
        DBManager.shared.selectAttributesQuery()
        
    }
    
    
    @IBAction func addAttribute(_ sender: UIButton) {
        let attributes_attr = ["name": attribute_name.text!, "layer_name": layer_name.text!, "value_type_id": DBManager.shared.valueTypeIDFromName(name: selectedValueType)] as [String : Any]?
        attribute_query_dicts.append(attributes_attr ?? ["": -1])
        attribute_name.text = ""
        print("adding attirbutes to list")
        print(attributes_attr)
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
