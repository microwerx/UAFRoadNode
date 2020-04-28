//
//  AddData.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class AddData: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // attributes [id: (name, value_type, data_type)
    var attributes = Array<[Int: [String: String]]>()
    var layer = String()
        
    var allCellsText = [String?](repeating: nil, count:5)
    var inputText: [String] = ["Test1", "Test2", "Test3", "Test4", "Test5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layer = DBManager.shared.getLayerName(node_id: selected_node)
        attributes = DBManager.shared.getLayerAttributes(layer_name: layer)
        print(attributes)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputText.count
    }
    
    var cells = [Int: String]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! addDataTableViewCell
        // look at addDataTableViewCell.swift file to see UILabel/Text Field names
        cell.textLabel?.text = inputText[indexPath.row]
        cell.addDataTextField?.delegate = self
        cell.addDataTextField?.text = inputText[indexPath.row]
        cell.addDataTextField?.autocorrectionType = UITextAutocorrectionType.no
        cell.addDataTextField?.autocapitalizationType = UITextAutocapitalizationType.none
        cell.addDataTextField?.adjustsFontSizeToFitWidth = true;
        cell.addDataTextField.tag = indexPath.row
        cells[indexPath.row] = cell.addDataTextField?.text
        return cell
    }
   
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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

