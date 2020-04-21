//
//  editLayerType.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 4/19/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

var layerNameArray = [String]()
var myIndex=0

class editLayerType: UIViewController {
    
    @IBOutlet weak var layerSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    func getData() {
        DBManager.shared.displayLayerNames()
        layerNameArray = DBManager.shared.layerNames
    }
    
    var searchedLayer = [String]()
    var searching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        layerSearch.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
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

extension editLayerType: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedLayer.count
        } else {
            return layerNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LayerName")
        if searching {
            cell?.textLabel?.text = searchedLayer[indexPath.row]
        } else {
            cell?.textLabel?.text = layerNameArray[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        myIndex = indexPath.row
        performSegue(withIdentifier: "editLayerSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showAlert(title: "Node DELETE Alert", message: "You sure you want to delete this node?", handlerOK: { action in
                
                //**********************************
                // Selected Attribute must be deleted the database first
                //**********************************
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }, handlerCancel: { actionCancel in print("Action cancel")
            })
            print("Deleted")
            
        }
    }
    
    
}

extension editLayerType: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedLayer = layerNameArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}

