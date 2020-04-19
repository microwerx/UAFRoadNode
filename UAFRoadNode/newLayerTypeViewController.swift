//
//  newLayerTypeViewController.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/18/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class newLayerTypeViewController: UIViewController {

    @IBOutlet weak var layer_name: UITextField!
    
    @IBAction func addNewLayerType(_ sender: UIButton) {
        let layer_attr = ["name": layer_name.text!, "creation_date": getDate(), "crypto": "test", "crypto_key": "test", "md5_hash": "test"]
        
        DBManager.shared.addLayerType(attr: layer_attr)
        DBManager.shared.selectLayersQuery()
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
