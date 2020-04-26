//
//  selectLayers.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/20/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class SelectLayers: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var layers = DBManager.shared.getLayerNames()
    var layers_dict = [Int : String]()
    var selected_layers = Array<String>()
    
    var cell = UITableViewCell()
    
    @IBOutlet weak var selectLayer_tableView: UITableView!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("selected_layers: \(selected_layers)")
        DBManager.shared.updateLayersOnDisplay(selected_layers: selected_layers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selected_layers = DBManager.shared.layersToDisplay()
        //for layer in layers {
        //    if DBManager.shared.layerIsOnDisplay(layer: layer) {
        //        selected_layers.append(layer)
        //    }
        //}
        
        selectLayer_tableView.dataSource = self
        selectLayer_tableView.delegate = self
    }
    
    // MARK: - Navigation

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layers.count
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        let layer = layers_dict[sender.tag] ?? ""
        let isOn = sender.isOn
        print("\(layer) layer switch changed")
        print("The switch is \(isOn ? "ON" : "OFF")")
        if isOn {
            if !selected_layers.contains(layer) {
                selected_layers.append(layer)
                print("added layer: \(layer) to select_layers: \(selected_layers)")
            }
        }
        else {
            if selected_layers.contains(layer) {
                selected_layers.remove(at: selected_layers.firstIndex(of: layer) ?? -1)
                print("removed layer \(layer) from selected_layers: \(selected_layers)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "Layers", for: indexPath)
        cell.textLabel?.text = layers[indexPath.row]
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(DBManager.shared.layerIsOnDisplay(layer: cell.textLabel?.text ?? ""), animated: true)
        switchView.tag = indexPath.row // for detect which row switch Changed
        layers_dict[indexPath.row] = cell.textLabel?.text
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }

}
