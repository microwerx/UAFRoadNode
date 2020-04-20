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
    
    var dataTypes: Array<String> = DBManager.shared.selectValueTypeNames()
    var selectedValueType = ""
    var attribute_query_dicts = Array<[String: Any]>()
    
    @IBOutlet weak var valueTableView: UITableView!
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet weak var newAttribute: UITextField!
    @IBOutlet weak var layerName: UILabel!
    
    @IBAction func addAttributeButton(_ sender: Any) {
        
       // Store the inputed Attribute to the correct Layer in the database
        
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
    
    func showAlert(title: String, message: String, handlerOK:((UIAlertAction) -> Void)?, handlerCancel:((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: . alert)
        let action = UIAlertAction(title: "OK", style: .destructive, handler: handlerOK)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: handlerCancel)
        alert.addAction(action)
        alert.addAction(actionCancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        showAlert(title: "Node DELETE Alert", message: "You sure you want to delete this node?", handlerOK: { action in
            
            //**********************************
            // Selected Attribute must be deleted the database first
            //**********************************
            
            self.detailTableView.deleteRows(at: [indexPath], with: .automatic)
            self.valueTableView.deleteRows(at: [indexPath], with: .automatic)
            
        }, handlerCancel: { actionCancel in print("Action cancel")
        })
        print("Deleted")
    
      }
    }
}
