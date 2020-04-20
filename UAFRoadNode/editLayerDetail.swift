//
//  editLayerDetail.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 4/19/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

var attributeLabelArray = [String]()
var valueTypeLabelArray = [String]()

class editLayerDetail: UIViewController {
    
    func getData() {
        DBManager.shared.selectAttributesQuery()
        attributeLabelArray = DBManager.shared.attributeNames
        DBManager.shared.selectValueTypeQuery()
        valueTypeLabelArray = DBManager.shared.valueTypeNames
    }
    
    let dataTypes = ["INTEGER", "REAL", "TEXT", "BLOB"]
    
    @IBOutlet weak var valueTableView: UITableView!
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet weak var newAttribute: UITextField!
    @IBOutlet weak var layerName: UILabel!
    
    @IBAction func addAttributeButton(_ sender: Any) {
        //Get the updated Array
        print(attributeLabelArray)
        print(valueTypeLabelArray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        layerName.text = layerNameArray[myIndex]
        getData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension editLayerDetail : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //Return Number of Rows
        if(tableView == detailTableView) {
            return attributeLabelArray.count
        }
        else {
            return dataTypes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(tableView == detailTableView) {
            //Define cell
            let cell = self.detailTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! layerDetailTableViewCell
            
            //Update Values
            cell.attributeLabel.text = attributeLabelArray[indexPath.row]
            cell.valueTypeLabel.text = valueTypeLabelArray[indexPath.row]
            
            //Return cell
            return cell
            }
            else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Value Type Cell", for: indexPath)
            
            cell.textLabel?.text = dataTypes[indexPath.row]
            
            return cell
        }
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    //    {
    //        //Switch case statement
    //        switch indexPath.row
    //        {
    //        //This Handle your first 4 case of Table Cell
    //        case 0,1,2,3:
    //            rightLabelArray[indexPath.row] = "1200"
    //            self.demoTableView.reloadRows(at: [indexPath], with: .none)
    //            break;
    //
    //        //This Handle your next 3 case of Table Cell
    //        case 4,5,6:
    //            rightLabelArray[indexPath.row] = "1500"
    //            self.demoTableView.reloadRows(at: [indexPath], with: .none)
    //        default:
    //            break;
    //        }
    //    }
    
}
