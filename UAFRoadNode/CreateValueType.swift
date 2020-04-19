//
//  CreateValueType.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/18/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class CreateValueType: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet var value_type_name: [UITextField]!
    

    @IBOutlet weak var myTableView: UITableView!
    
    let dataTypes = ["\"INTEGER\"", "\"REAL\"", "\"TEXT\"", "\"BLOB\""]
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
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
