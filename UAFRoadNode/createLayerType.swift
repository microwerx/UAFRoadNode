//
//  createLayerType.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 4/15/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class createLayerType: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addLayerTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var attributes = [String]()

    @IBAction func addAttributeButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add Attribute", message: nil, preferredStyle: .alert)
        alert.addTextField { (attributeTF) in
            attributeTF.placeholder = "Enter New Attribute Type"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let attribute = alert.textFields?.first?.text else { return }
            print(attribute)
            self.add(attribute)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }

        func add(_ attribute: String) {
            let index = 0
            attributes.insert(attribute, at: index)
            
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .left)
        }

    }

    extension createLayerType: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return attributes.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            let attribute = attributes[indexPath.row]
            cell.textLabel?.text = attribute
            return cell
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard editingStyle == .delete else { return }
            attributes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

