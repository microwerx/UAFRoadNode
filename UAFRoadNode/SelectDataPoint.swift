//
//  SelectDataPoint.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski  on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

var selectedDataPoint = 0

class SelectDataPoint: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
    let dataPoints = DBManager.shared.getDataPoints(node_id: selected_node)

    
    override func viewWillAppear(_ animated: Bool) {
        selectedDataPoint = 0
    }
    
    @IBAction func submit(_ sender: Any) {
        print(selectedDataPoint)
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDataPoint = dataPoints[indexPath.row]
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPoints.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Data Point", for: indexPath)
        let cell_text = DBManager.shared.getDataPointDateTime(dp_id: dataPoints[indexPath.row])
        cell.textLabel?.text = cell_text
        selectedDataPoint = dataPoints[indexPath.row]
        return cell
    }
}
