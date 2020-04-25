//
//  editLayerDetail.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 4/19/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class editLayerDetail: UIViewController {
    
    
    @IBOutlet weak var layerName: UILabel!
    @IBOutlet weak var newLayerName: UITextField!
     
    @IBAction func submitNewLayerName(_ sender: Any) {
        //UPDATE Database here with update layername query
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        layerName.text = layerNameArray[myIndex]
        
    }
    
    // TODO: [display an on screen warning if new layer name already exists]
}
