//
//  SelectNodeType.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski  on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

var selectedNodeType = ""

class SelectNodeType: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
    let nodeTypes = DBManager.shared.getLayerNames()

    
    override func viewWillAppear(_ animated: Bool) {
        selectedNodeType = ""
    }
    
    
    @IBAction func submit(_ sender: Any) {
        print(selectedNodeType)
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNodeType = nodeTypes[indexPath.row]
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeTypes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Node Type", for: indexPath)
        
        cell.textLabel?.text = nodeTypes[indexPath.row]
        selectedNodeType = cell.textLabel?.text ?? ""
        return cell
    }
}
