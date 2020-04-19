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
    
    var attributes = [String]()
    var names = [String]()
    var currentLayerNames = [String]()
        
    @IBAction func addNewLayerType(_ sender: UIButton) {
        let layer_attr = ["name": addLayerTextField.text!, "creation_date": getDate(), "crypto": "test", "crypto_key": "test", "md5_hash": "test"]
        
        DBManager.shared.addLayerType(attr: layer_attr)
        DBManager.shared.selectLayersQuery()
        DBManager.shared.displayLayerNames()
        names = DBManager.shared.layerNames
        print(names)
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
        // Do any additional setup after loading the view.
    }
}

//extension createLayerType: UITableViewDataSource {
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return currentLayerNames.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        let attribute = currentLayerNames[indexPath.row]
//        cell.textLabel?.text = attribute
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard editingStyle == .delete else { return }
//        currentLayerNames.remove(at: indexPath.row)
//
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//    }
//
//}
