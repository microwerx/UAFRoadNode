//
//  selectLayers.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/20/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class SelectLayers: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var layers = Array<String>()
    var selectedLayer = String()
    @IBOutlet weak var selectLayer_tableView: UITableView!
    

    
    @IBAction func layerSwitchChanged(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        selectLayer_tableView.dataSource = self
        selectLayer_tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLayer = layers[indexPath.row]
    }
    
    func getData() {
        DBManager.shared.displayLayerNames()
        layers = DBManager.shared.layerNames
    }
    // MARK: - Navigation

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Layers", for: indexPath)
        
        cell.textLabel?.text = layers[indexPath.row]
        
        return cell
    }

}
