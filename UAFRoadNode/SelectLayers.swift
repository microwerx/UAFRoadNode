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
    var layers_dict = [Int : String]()
    
    var cell = UITableViewCell()
    
    @IBOutlet weak var selectLayer_tableView: UITableView!
    
    
    //@IBOutlet weak var `switch`: UISwitch!
    //@IBAction func layerSwitchChanged(_ sender: Any) {
    //    if cell ==  selectLayer_tableView.cellForRow(at: IndexPath(row: (sender as AnyObject).tag, section: 0))! {
    //        print("cell label: \(cell.textLabel?.text ?? "")")}
    //}
    
    override func viewWillDisappear(_ animated: Bool) {
        //var selectedLayers = Array<String>()
        //for (i, layer) in layers.enumerated() {
        //    if (selectLayer_tableView.cellForRow(at: IndexPath(index: (0, i))) != nil) {
        //        print("viewWillDissapear: \(i) : \(layer)")
        //    }
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layers = DBManager.shared.getLayerNames()
        print("loaded layers: \(layers)")
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

        print("\(layers_dict[sender.tag] ?? "") layer switch changed")
          print("The switch is \(sender.isOn ? "ON" : "OFF")")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "Layers", for: indexPath)
        cell.textLabel?.text = layers[indexPath.row]
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row // for detect which row switch Changed
        layers_dict[indexPath.row] = cell.textLabel?.text
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }

}
