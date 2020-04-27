//
//  CreateValueType.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/18/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class CreateValueType: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    
    let dataTypes = ["INTEGER", "REAL", "TEXT", "BLOB"]
    
    
    @IBOutlet weak var value_type_name: UITextField!
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        value_type_name.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    var selectedDatatype = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDatatype = dataTypes[indexPath.row]
    }
    
    // TODO: [display an on screen warning if already exists]
    @IBAction func submit(_ sender: UIButton) {
        let value_type_attr = ["name": value_type_name.text!, "data_type": selectedDatatype]
        
        if(value_type_name.text != "") {
            let confirmMessage = UIAlertController(title: "Confirm", message: "You have successfully added a new value type.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
            })
            
            confirmMessage.addAction(ok)
            self.present(confirmMessage, animated: true, completion: nil)
        }
        
        if(value_type_name.text == "") {
            let errorMessage = UIAlertController(title: "Error", message: "You need to enter a value type name.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
            })
            
            errorMessage.addAction(ok)
            self.present(errorMessage, animated: true, completion: nil)
        }
        
        DBManager.shared.addValueType(attr: value_type_attr)
        DBManager.shared.selectValueTypeQuery()
        value_type_name.text? = ""
        
    }
    
    
    // MARK: - Navigation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Data Types", for: indexPath)
        
        cell.textLabel?.text = dataTypes[indexPath.row]
        
        return cell
    }
    
}
