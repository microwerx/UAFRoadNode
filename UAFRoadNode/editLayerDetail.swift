//
//  editLayerDetail.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 4/19/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class editLayerDetail: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var layerName: UILabel!
    @IBOutlet weak var newLayerName: UITextField!
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
     
    @IBAction func submitNewLayerName(_ sender: Any) {
        
        // TODO: Check db and confirm created_locally attribute is true
        // Disallow update and issue warning if false.
        
        DBManager.shared.editLayerName(old_name: layerName.text!, new_name: newLayerName.text!)
        _ = navigationController?.popViewController(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        layerName.text = layerNameArray[myIndex]
        newLayerName.delegate = self
        
    }
    
    // TODO: [display an on screen warning if new layer name already exists]
}
