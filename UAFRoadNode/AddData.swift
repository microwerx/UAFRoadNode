//
//  AddData.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/26/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class AddData: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    let animals: [String] = ["Test1", "Test2", "Test3", "Test4", "Test5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var allCellsText = [String?](repeating: nil, count:5)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! addDataTableViewCell
        cell.addDataTextField?.delegate = self
        cell.addDataTextField?.text = ""
        cell.addDataTextField?.placeholder = animals[indexPath.row]
        cell.addDataTextField?.autocorrectionType = UITextAutocorrectionType.no
        cell.addDataTextField?.autocapitalizationType = UITextAutocapitalizationType.none
        cell.addDataTextField?.adjustsFontSizeToFitWidth = true;
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexOf = animals.firstIndex(of:textField.placeholder!)
        print(indexOf as Any)
        if(textField.placeholder! == animals[indexOf!]){
            if( indexOf! <= (allCellsText.count - 1)){
                allCellsText.remove(at: indexOf!)
            }
            allCellsText.insert(textField.text!, at: indexOf!)
            print(allCellsText)
        }
    }
    
    //delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {           textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

