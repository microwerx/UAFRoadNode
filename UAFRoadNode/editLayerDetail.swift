//
//  editLayerDetail.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski on 4/19/20.
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
        
        // TODO: [Check db and confirm created_locally attribute is true
        // Disallow update and issue warning if false.]
        
        if(newLayerName.text != "") {
            let confirmMessage = UIAlertController(title: "Confirm", message: "You have successfully changed the layer name.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
            })
            
            confirmMessage.addAction(ok)
            self.present(confirmMessage, animated: true, completion: nil)
            
            DBManager.shared.editLayerName(old_name: layerName.text!, new_name: newLayerName.text!)
            layerName.text = newLayerName.text!
            newLayerName.text = ""
        }
        
        if(newLayerName.text == "") {
            let errorMessage = UIAlertController(title: "Error", message: "You need to enter a new name.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("Ok button tapped")
            })
            
            errorMessage.addAction(ok)
            self.present(errorMessage, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        layerName.text = layerNameArray[myIndex]
        newLayerName.delegate = self
        
    }
    
    // TODO: [display an on screen warning if new layer name already exists]
}
