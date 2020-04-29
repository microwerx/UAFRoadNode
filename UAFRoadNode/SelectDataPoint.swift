//
//  SelectDataPoint.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski  on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

var selectedDataPoint = 0
var selectedDateTime = ""

class SelectDataPoint: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    let dataPoints = DBManager.shared.getDataPoints(node_id: selected_node)
    
    var date_labels = Array<String>()
    
    func build_date_labels() {
        var date_times = Array<String>()
        for dp in dataPoints {
            date_times.append(DBManager.shared.getDataPointDateTime(dp_id: dp))
        }
        date_labels = Array(Set(date_times))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedDataPoint = 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build_date_labels()
        myTableView.dataSource = self
        myTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDateTime = date_labels[indexPath.row]
        performSegue(withIdentifier: "showData", sender: nil)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return date_labels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Data Point", for: indexPath)
        let cell_text = date_labels[indexPath.row]
        cell.textLabel?.text = cell_text
        //selectedDataPoint = dataPoints[indexPath.row]
        return cell
    }
}
