//
//  DBManager.swift
//  UAFRoadNode
//
//  Created by Nami Kim and Alex Lewandowski  on 4/7/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit


class DBManager: NSObject {
    
    static let shared: DBManager = DBManager()
    
    let field_layers_id = "id"
    let field_layers_name = "name"
    let field_layers_creationDate = "creation_date"
    let field_layers_crypto = "crypto"
    let field_layers_cryptoKey = "crypto_key"
    let field_layers_md5Hash = "md5_hash"
    let field_layers_createdLocally = "created_locally"
    let field_layers_onDisplay = "on_display"
    
    let field_valueTypes_id = "id"
    let field_valueTypes_name = "name"
    let field_valueTypes_dataType = "data_type"
    
    let field_nodes_id = "id"
    let field_nodes_name = "name"
    let field_nodes_lat = "latitude"
    let field_nodes_long = "longitude"
    let field_nodes_layerName = "layer_name"
    
    let field_attributes_id = "id"
    let field_attributes_name = "name"
    let field_attributes_layerName = "layer_name"
    let field_attributes_valueTypeID = "value_type_id"
    
    let field_data_id = "id"
    let field_data_integerValue = "int_value"
    let field_data_textValue = "text_value"
    let field_data_real_value = "real_value"
    let field_data_numeric_value = "numeric_value"
    let field_data_dateTimeAdded = "date_time_added"
    let field_data_attrID = "attribute_id"
    let field_data_nodeID = "node_id"
    
    let databaseFileName = "database.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    var layerNames = [String]()
    var attributeNames = [String]()
    var valueTypeNames = [String]()
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            print("Creating empty database")
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    print("Opened FMDatabase")
                    let createLayersTableQuery = "CREATE TABLE layers (\(field_layers_id) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_layers_name) VARCHAR(45) NOT NULL, \(field_layers_creationDate) DATETIME NOT NULL, \(field_layers_crypto) VARCHAR(45), \(field_layers_cryptoKey) VARCHAR(45), \(field_layers_md5Hash) VARCHAR(45), \(field_layers_createdLocally) INTEGER NOT NULL, \(field_layers_onDisplay) INTEGER NOT NULL, UNIQUE (\(field_layers_name)));"
                    
                    let createValueTypesTableQuery = "CREATE TABLE value_types (\(field_valueTypes_id) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_valueTypes_name) VARCHAR(45) NOT NULL, \(field_valueTypes_dataType) VARCHAR(45) NOT NULL, UNIQUE (\(field_valueTypes_name)));"
                    
                    let createNodesTableQuery = "CREATE TABLE nodes (\(field_nodes_id) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_nodes_name) VARCHAR(45) NOT NULL, \(field_nodes_lat) DECIMAL(9, 6) NOT NULL, \(field_nodes_long) DECIMAL(9, 6) NOT NULL, \(field_nodes_layerName) VARCHAR(45) REFERENCES layers(\(field_layers_name)) ON UPDATE CASCADE);"
                    
                    let createAttributesTableQuery = "CREATE TABLE attributes (\(field_attributes_id) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_attributes_name) VARCHAR(45) NOT NULL, \(field_attributes_layerName) VARCHAR(45) REFERENCES layers(\(field_layers_name)) ON UPDATE CASCADE, \(field_attributes_valueTypeID) INTEGER REFERENCES units(\(field_valueTypes_id)) ON UPDATE CASCADE);"
                    
                    let createDataPointTableQuery = "CREATE TABLE data_point (\(field_data_id) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_data_integerValue) INTEGER, \(field_data_textValue) TEXT, \(field_data_real_value) REAL, \(field_data_numeric_value) NUMERIC, \(field_data_dateTimeAdded) DATETIME NOT NULL, \(field_data_attrID) INTEGER REFERENCES attributes(\(field_attributes_id)) ON UPDATE CASCADE, \(field_data_nodeID) INTEGER REFERENCES nodes(\(field_nodes_id)) ON UPDATE CASCADE);"
                    
                    
                    let create_table_queries: [String] = [createLayersTableQuery, createValueTypesTableQuery, createNodesTableQuery, createAttributesTableQuery, createDataPointTableQuery]
                    
                    
                    // Add the tables
                    for query in create_table_queries {
                        do {
                            
                            try database.executeUpdate(query, values: nil)
                            created = true
                        }
                        catch {
                            print("Could not create table with query: \(query).")
                            print(error.localizedDescription)
                        }
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        print("There is no database")
        return false
    }
    
    
    // SELECT * Queries //
    
    func selectLayersQuery() {
        if openDatabase() {
            do {
                let query = "SELECT * FROM layers"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                while (rsMain!.next() == true) {
                    let id = rsMain?.string(forColumn: field_layers_id)
                    let name = rsMain?.string(forColumn: field_layers_name)
                    let date = rsMain?.string(forColumn: field_layers_creationDate)
                    let crypto = rsMain?.string(forColumn: field_layers_crypto)
                    let cryptoKey = rsMain?.string(forColumn: field_layers_cryptoKey)
                    let md5Hash = rsMain?.string(forColumn: field_layers_md5Hash)
                    let createdLocally = rsMain?.string(forColumn: field_layers_createdLocally)
                    let onDisplay = rsMain?.string(forColumn: field_layers_onDisplay)
                    print(" layers.id: \(id!)\n layers.name: \(name!)\n layers.date: \(date!)\n layers.crypto: \(crypto!)\n layers.cryptoKey: \(cryptoKey!)\n layers.md5Hash: \(md5Hash!)\n layers.created_locally: \(createdLocally!)\n layers.on_display: \(onDisplay!)\n")
                }
            }
            database.close()
        }
    }
    
    func selectValueTypeQuery() {
        if openDatabase() {
            do {
                let query = "SELECT * FROM value_types"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                while (rsMain!.next() == true) {
                    let id = rsMain?.string(forColumn: field_valueTypes_id)
                    let name = rsMain?.string(forColumn: field_valueTypes_name)
                    let data_type_id = rsMain?.string(forColumn: field_valueTypes_dataType)
                    print(" value_types.id: \(id!)\n value_types.name: \(name!)\n value_types.data_type: \(data_type_id!)\n")
                    valueTypeNames.append(name!)
                }
            }
            database.close()
        }
    }
    
    func selectAttributesQuery() {
        if openDatabase() {
            do {
                let query = "SELECT * FROM attributes"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                while (rsMain!.next() == true) {
                    let id = rsMain?.string(forColumn: field_attributes_id)
                    let name = rsMain?.string(forColumn: field_attributes_name)
                    let layer_name = rsMain?.string(forColumn: field_attributes_layerName)
                    let value_type_id = rsMain?.string(forColumn: field_attributes_valueTypeID)
                    print(" attributes.id: \(id!)\n attributes.name: \(name!)\n attributes.layer_name: \(layer_name!)\n attributes.value_type_id: \(value_type_id!)\n")
                    attributeNames.append(name!)
                }
            }
            database.close()
        }
    }
    
    func selectNodesQuery() {
      if openDatabase() {
                do {
                    let query = "SELECT * FROM nodes"
                    let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                    while (rsMain!.next() == true) {
                        let id = rsMain?.string(forColumn: field_nodes_id)
                        let name = rsMain?.string(forColumn: field_nodes_name)
                        let latitude = rsMain?.string(forColumn: field_nodes_lat)
                        let longitude = rsMain?.string(forColumn: field_nodes_long)
                        let layer_name = rsMain?.string(forColumn: field_nodes_layerName)
                        print(" nodes.id: \(id!)\n nodes.name: \(name!)\n nodes.latitude: \(latitude!)\n nodes.longitude: \(longitude!)\n nodes.layer_name: \(layer_name!)\n")
                    }
                }
                database.close()
            }
        }
    
    
    func selectDataPointQuery() {
    if openDatabase() {
              do {
                  let query = "SELECT * FROM data_point"
                  let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                  while (rsMain!.next() == true) {
                      let id = rsMain?.string(forColumn: field_data_id) ?? ""
                      let int_value = rsMain?.string(forColumn: field_data_integerValue) ?? ""
                      let text_value = rsMain?.string(forColumn: field_data_textValue) ?? ""
                      let real_value = rsMain?.string(forColumn: field_data_real_value) ?? ""
                      let numeric_value = rsMain?.string(forColumn: field_data_numeric_value) ?? ""
                      let dateTimeAdded = rsMain?.string(forColumn: field_data_dateTimeAdded) ?? ""
                      let attribute_id = rsMain?.string(forColumn: field_data_attrID) ?? ""
                      let node_id = rsMain?.string(forColumn: field_data_nodeID) ?? ""
                    print("Data Point Query:  data_point.id: \(id)\n data_point.int_value: \(int_value)\n data_point.text_value: \(text_value)\n data_point.real_value: \(real_value)\n data_point.numeric_value: \(numeric_value)\n data_point.datTimeAdded\(dateTimeAdded)\n data_point.attribute_id: \(attribute_id)\n data_point.node_id: \(node_id)\n")
                  }
              }
              database.close()
          }
      }

    
    // Other select Queries
    
    func selectValueTypeNames() -> Array<String> {
        if openDatabase() {
            do {
                let query = "SELECT * FROM value_types;"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: ([]))
                var ids = [String]()
                while (rsMain!.next() == true) {
                    ids.append((rsMain?.string(forColumn: field_valueTypes_name))!)
                }
                database.close()
                return ids
            }
        }
        return [""]
    }
    
    
    func valueTypeIDFromName(name: String) -> Int32 {
        if openDatabase() {
            do {
                let query = "SELECT * FROM value_types WHERE \(field_valueTypes_name) = \"\(name)\";"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                print(query)
                var id = Int32()
                while (rsMain!.next() == true) {
                    id = rsMain?.int(forColumn: field_valueTypes_id) ?? -1
                }
                database.close()
                print(id)
                return id
            }
        }
        return -1
    }
    
    
    func selectValueTypeName(id: Int32) -> String {
        if openDatabase() {
            do {
                let query = "SELECT * FROM value_types WHERE \(field_valueTypes_id) = \(id);"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                let name = rsMain?.string(forColumn: field_valueTypes_name)
                database.close()
                return name!
            }
        }
        return ""
    }
    
    
    func getDataPoints(node_id: Int) -> Array<Int> {
        var dp_ids = Array<Int>()
        if openDatabase() {
            do {
                let query = "SELECT \(field_data_id) FROM data_point WHERE \(field_data_nodeID)=\(node_id);"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                while (rsMain!.next() == true) {
                    let id = Int(rsMain?.string(forColumn: field_data_id) ?? "") ?? -1
                    dp_ids.append(id)
                }
            }
            database.close()
        }
        return dp_ids
    }
    
    func getDataPointDateTime(dp_id: Int) -> String {
        var dp_date_time = String()
            if openDatabase() {
                do {
                    let query = "SELECT \(field_data_dateTimeAdded) FROM data_point WHERE \(field_data_id)=\(dp_id);"
                    let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                    while (rsMain!.next() == true) {
                        dp_date_time = rsMain?.string(forColumn: field_data_dateTimeAdded) ?? ""
                    }
                }
                database.close()
            }
        return dp_date_time
    }
    
    
    
    func getLayerNames() -> Array<String>{
        var layerNames = Array<String>()
        if openDatabase() {
            do {
                let query = "SELECT \(field_layers_name) FROM layers"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                while (rsMain!.next() == true) {
                    let name = rsMain?.string(forColumn: field_layers_name)
                    layerNames.append(name!)
                }
            }
            database.close()
        }
        return layerNames
    }
    
    
    func layerIsOnDisplay(layer: String) -> Bool {
        var isOn = false
        if openDatabase() {
            do {
                let query = "SELECT \(field_layers_onDisplay) FROM layers WHERE \(field_layers_name)=\"\(layer)\";"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                while (rsMain!.next() == true) {
                    if Int((rsMain?.string(forColumn: field_layers_onDisplay))!) == 1 {
                        isOn = true
                    }
                }
            }
            database.close()
        }
        return isOn
    }
    
    
    func layersToDisplay() -> Array<String> {
        let all_layers = getLayerNames()
        var layers_to_display = Array<String>()
        for layer in all_layers {
            if layerIsOnDisplay(layer: layer) {
                layers_to_display.append(layer)
            }
        }
        return layers_to_display
    }
    
    func nodes_to_display() -> Array<Int> {
        var nodes_to_display = Array<Int>()
        for layer in layersToDisplay() {
            if openDatabase() {
                do {
                    let query = "SELECT \(field_nodes_id) FROM nodes WHERE \(field_nodes_layerName)=\"\(layer)\";"
                    let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                        while (rsMain!.next() == true) {
                            let id = Int(rsMain?.string(forColumn: field_nodes_id) ?? "-1")
                            if id != -1 {
                                nodes_to_display.append(id!)
                            }
                        }
                }
                database.close()
            }
        }
        return nodes_to_display
    }
    
    
    func getLayerName(node_id: Int) -> String{
        var layer_name = ""
        if openDatabase() {
            do {
                let query = "SELECT \(field_nodes_layerName) FROM nodes WHERE \(field_nodes_id)=\"\(node_id)\";"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                    while (rsMain!.next() == true) {
                        layer_name = rsMain?.string(forColumn: field_nodes_layerName) ?? "-1"
                        }
                    }
            database.close()
            }
        return layer_name
    }
    
    
    func getNodeCoord(node_id: Int) -> [String: Double]{
        var coord = [String: Double]()
            if openDatabase() {
                do {
                    let query = "SELECT \(field_nodes_lat), \(field_nodes_long) FROM nodes WHERE \(field_nodes_id)=\"\(node_id)\";"
                    let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                        while (rsMain!.next() == true) {
                            let latitude = Double(rsMain?.string(forColumn: field_nodes_lat) ?? "-1.0") ?? -1.0
                            let longitude = Double(rsMain?.string(forColumn: field_nodes_long) ?? "-1.0") ?? -1.0
                            coord["latitude"] = latitude
                            coord["longitude"] = longitude
                            }
                        }
                database.close()
                }
            return coord
        }
    
    
    func getNodeName(node_id: Int) -> String {
        var name = String()
            if openDatabase() {
                do {
                    let query = "SELECT \(field_nodes_name) FROM nodes WHERE \(field_nodes_id)=\"\(node_id)\";"
                    let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                        while (rsMain!.next() == true) {
                            name = rsMain?.string(forColumn: field_nodes_name) ?? ""
                            }
                        }
                database.close()
                }
            return name
        }
    
    
    func getDataType(value_type_id: Int) -> String {
    var name = String()
        if openDatabase() {
            do {
                let query = "SELECT * FROM value_types WHERE \(field_valueTypes_id)=\"\(value_type_id)\";"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                    while (rsMain!.next() == true) {
                        name = rsMain?.string(forColumn: field_valueTypes_id) ?? ""
                        }
                    }
            database.close()
            }
        return name
    }
    
    

    func getLayerAttributes(layer_name: String) -> [Int: [String: String]] {
        var attributes = [Int: [String: String]]()
            if openDatabase() {
                do {
                    let query = "SELECT a.\(field_attributes_id), a.\(field_attributes_name) AS a_name, v.\(field_valueTypes_name) AS v_name, v.\(field_valueTypes_dataType) FROM attributes AS a INNER JOIN value_types AS v ON a.\(field_attributes_valueTypeID) = v.\(field_valueTypes_id) AND a.\(field_attributes_layerName)=\"\(layer_name)\";"
                    let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                        while (rsMain!.next() == true) {
                            let attr_name = rsMain?.string(forColumn: "a_name") ?? ""
                            let attr_id = Int(rsMain?.string(forColumn: field_attributes_id) ?? "") ?? -1
                            let value_type_name = rsMain?.string(forColumn: "v_name") ?? ""
                            let value_data_type = rsMain?.string(forColumn: field_valueTypes_dataType) ?? ""
                            var details = [String: String]()
                            details["attr_name"] = attr_name
                            details[value_type_name] = value_data_type
                            attributes[attr_id] = details
                            }
                        }
                database.close()
                }
            return attributes
        }
    
    
    func getDataPointValue(attr_id: Int, data_type: String, node_id: Int, date_time: String) -> String {
        var value = String()
        var field_data_value = ""
        if data_type == "REAL" {
            field_data_value = field_data_real_value
        }
        else if data_type == "NUMERIC" {
            field_data_value = field_data_numeric_value
        }
        else if data_type == "INTEGER" {
            field_data_value = field_data_integerValue
        }
        else if data_type == "TEXT" {
            field_data_value = field_data_textValue
        }
        else{
            // TODO : Do something here when adding BLOB data
        }
        if openDatabase() {
            do {
                let query = "SELECT \(field_data_value) FROM data_point WHERE \(field_data_attrID)=\(attr_id) AND \(field_data_nodeID)=\(node_id) AND \(field_data_dateTimeAdded)=\"\(date_time)\";"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                    while (rsMain!.next() == true) {
                        value = rsMain?.string(forColumn: field_data_value) ?? ""
                        }
                    }
            database.close()
            }
        return value
    }
    
    
    // isUnique attribute query functions
    
    func isUnique_layerName(name: String) -> Bool {
        if openDatabase() {
            do {
                let query = "SELECT \"name\" FROM layers;"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                var n = String()
                while (rsMain!.next() == true) {
                    n = rsMain?.string(forColumn: "name") ?? ""
                    if n == name {
                        database.close()
                        print(n)
                        return false
                    }
                }
                database.close()
                return true
            }
        }
        else {
            return false
        }
    }
    

    // INSERT Functions
    
    func addLayerType(attr: [String: Any]) {
        if openDatabase() {
            
            do {
                // check that there is a value for each attribute
               
                let query = "INSERT INTO layers (\(field_layers_name), \(field_layers_creationDate), \(field_layers_crypto), \(field_layers_cryptoKey), \(field_layers_md5Hash), \(field_layers_createdLocally), \(field_layers_onDisplay)) VALUES (\"\(attr[field_layers_name] ?? "")\", \"\(attr[field_layers_creationDate] ?? "")\", \"\(attr[field_layers_crypto] ?? "")\", \"\(attr[field_layers_cryptoKey] ?? "")\", \"\(attr[field_layers_md5Hash] ?? "")\", \"\(attr[field_layers_createdLocally] ?? 1)\", \"\(attr[field_layers_onDisplay] ?? 1)\");"
                
                if !database.executeStatements(query) {
                    print("Failed to insert new layer type")
                    print(database.lastError(), database.lastErrorMessage())
                    
                }
                
                else{
                    print("Error: passed null value/s in dict to addLayerType")
                    
                }
            }
            
        }
        database.close()
        
    }
    
    
    func addValueType(attr: [String: String]) {
        if openDatabase() {
            do {
                // check that there is a value for each attribute
                var empty = false
                for (_, val) in attr {
                    if val.count == 0 {
                        empty = true
                    }
                }
                if !empty {
                    let query = "INSERT INTO value_types (\(field_valueTypes_name), \(field_valueTypes_dataType)) VALUES (\"\(attr[field_valueTypes_name] ?? "")\", \"\(attr[field_valueTypes_dataType] ?? "")\");"
                    if !database.executeStatements(query) {
                        print("Failed to insert new layer type")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                else{
                    print("Error: passed null value/s in dict to addLayerType")
                }
            }
        }
        database.close()
    }
    
    
    func addAttribute(attr: [String: Any]) {
        if openDatabase() {
            do {
                let query = "INSERT INTO attributes (\(field_attributes_name), \(field_attributes_layerName), \(field_attributes_valueTypeID)) VALUES (\"\(attr[field_attributes_name] ?? "")\", \"\(attr[field_attributes_layerName] ?? "")\", \"\(attr[field_attributes_valueTypeID] ?? -1)\");"
                if !database.executeStatements(query) {
                    print("Failed to insert new atrtribute type")
                    print(database.lastError(), database.lastErrorMessage())
                }
            }
        }
        database.close()
    }
    

    func addNode(attr: [String: Any]) {
        if openDatabase() {
            do {
                let query = "INSERT INTO nodes (\(field_nodes_name), \(field_nodes_lat), \(field_nodes_long), \(field_nodes_layerName)) VALUES (\"\(attr[field_nodes_name] ?? "")\", \"\(attr[field_nodes_lat] ?? -1.0)\", \"\(attr[field_nodes_long] ?? -1.0)\", \"\(attr[field_nodes_layerName] ?? "")\");"
                if !database.executeStatements(query) {
                    print("Failed to add new node")
                    print(database.lastError(), database.lastErrorMessage())
                }
            }
        }
        selectNodesQuery()
        database.close()
    }
    
    
    func addDataPoint(attributes: [Int: [String: Any]]) {
        for (_, attr_info) in attributes {
            if openDatabase() {
                do {
                    let query = "INSERT INTO data_point (\(field_data_integerValue), \(field_data_textValue), \(field_data_real_value), \(field_data_numeric_value), \(field_data_dateTimeAdded), \(field_data_attrID), \(field_data_nodeID)) VALUES (\(attr_info[field_data_integerValue] ?? -1), \"\(attr_info[field_data_textValue] ?? "")\", \(attr_info[field_data_real_value] ?? -1.0), \(attr_info[field_data_numeric_value] ?? -1), \"\(attr_info[field_data_dateTimeAdded] ?? "")\", \(attr_info[field_data_attrID] ?? -1), \(attr_info[field_data_nodeID] ?? -1));"
                    print(query)
                    if !database.executeStatements(query) {
                        print("Failed to insert new atrtribute type")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
            }
            database.close()
            selectDataPointQuery()
        }
    }

    
    // DELETE Queries
    
    func deleteLayerType(layer_name: String) {
        if openDatabase() {
            do {
                let query = "DELETE FROM layers WHERE \(field_layers_name) = \"\(layer_name)\";"
                if !database.executeStatements(query) {
                    print("Failed to delete layer type \"\(layer_name)\"")
                    print(database.lastError(), database.lastErrorMessage())
                    }
                
                else {
                    print("Deleted layer type \"\(layer_name)\" from the layers database")
                    }
                }
            database.close()
        }
    }

    // UPDATE functions
    
    func editLayerName(old_name: String, new_name: String) {
        if openDatabase() {
            do {
                let query = "UPDATE layers SET \(field_layers_name) = '\(new_name)' WHERE \(field_layers_name) = '\(old_name)';"
                
                if !database.executeStatements(query) {
                    print("Failed to update layer name \"\(old_name)\" to \"\(new_name)\"")
                    print(database.lastError(), database.lastErrorMessage())
                }
                
                else{
                    print("Updated layer name \"\(old_name)\" to \"\(new_name)\"")
                }
            }
        }
        database.close()
    }
    
    func updateLayersOnDisplay(selected_layers: Array<String>) {
        let all_layers = getLayerNames()
        for layer in all_layers {
            if openDatabase() {
                do {
                        var query = ""
                        if selected_layers.contains(layer) {
                            print("\(layer) onDisplay")
                            query = "UPDATE layers SET \(field_layers_onDisplay) = 1 WHERE \(field_layers_name) = '\(layer)';"
                        }
                        else {
                              print("\(layer) NOT onDisplay")
                            query = "UPDATE layers SET \(field_layers_onDisplay) = 0 WHERE \(field_layers_name) = '\(layer)';"
                        }
                        if !database.executeStatements(query) {
                            print("Failed to update \(layer) on_display")
                            print(database.lastError(), database.lastErrorMessage())
                        }
                        
                        else{
                            print("Updated \(layer) on_display")
                        }
                }
                database.close()
            }
        }
    }
    
    
    
    
}

