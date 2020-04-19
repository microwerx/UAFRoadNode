//
//  DBManager.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski  on 4/7/20.
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
    
    override init() {
        super.init()
     
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    func createDatabase() -> Bool {
        var created = false
        
        // Uncomment if statement below to delete the database for development
        /*
        if FileManager.default.fileExists(atPath: pathToDatabase) {
            do {
                print("Deleting db")
                try FileManager.default.removeItem(atPath: pathToDatabase)
            }
            catch {
                print("Could not remove db")
                print(error.localizedDescription)
            }
        }
        return true
        */
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            print("Creating empty database")
            database = FMDatabase(path: pathToDatabase!)
     
        if database != nil {
            // Open the database.
            if database.open() {
                print("Opened FMDatabase")
                let createLayersTableQuery = "CREATE TABLE layers (\(field_layers_id) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_layers_name) VARCHAR(45) NOT NULL, \(field_layers_creationDate) DATETIME NOT NULL, \(field_layers_crypto) VARCHAR(45), \(field_layers_cryptoKey) VARCHAR(45), \(field_layers_md5Hash) VARCHAR(45), UNIQUE (\(field_layers_name)));"
                
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
     
        return false
    }
    

    
    func insertTestRow() {
        // Open the database.
        var query = ""
        if openDatabase() {
            query += "INSERT INTO value_types (\(field_valueTypes_name), \(field_valueTypes_dataType)) VALUES (\"mph\", \"INTEGER\");"
            //query += "INSERT INTO layers (\(field_layers_name), \(field_layers_creationDate), \(field_layers_crypto), \(field_layers_cryptoKey), \(field_layers_md5Hash)) VALUES ('test', 103019, 'crypto', 'cryptokey', 'gg34hj5g3jh4g5hj3g4jh5g');"
            do {
                if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
            }
            //catch {
            //        print(error.localizedDescription)
            //    }
        }
        database.close()
    }
    

    /*
    func add_sample_rows() {
        if openDatabase() {
        do {
            let insert_layers = "INSERT INTO layers (\(field_layers_name), \(field_layers_crypto), \(field_layers_cryptoKey), \(field_layers_creationDate), \(field_layers_md5Hash)) VALUES (\"Traffic Accidents\", \"kjhkjhkj\", \"awd6ffdfdg6fg5f6566s5fd\", \"10-13-19\");"
            
            let insert_value_types = "INSERT INTO value_types (\(field_valueTypes_name), \(field_valueTypes_DataType)) VALUES (\"mph\", \"INTEGER\");"
            }
            
            let insert_nodes = "INSERT INTO nodes (\(field_nodes_name), \(field_nodes_lat), \(field_nodes_long), \(field_nodes_layerName)) VALUES (\"University Ave. and College Rd.\", 64.8557, -147.8131, \"Traffic_Accidents\");"
            
            let insert_attributes = "INSERT INTO attributes (\(field_attributes_name), \(field_attributes_valueTypeID), \(field_attributes_layerName) VALUES (\"speed\", 1, \"Traffic Accidents\");"
            
            let insert_data_point = "INSERT INTO data_point (\(field_data_attrID), \(field_data_nodeID), \(field_data_integerValue), \(field_data_dateTimeAdded));"
        }
        
    }
    */
    
    func execTestQuery() {
        if openDatabase() {
            do {
                let mainQuery = "SELECT \(field_valueTypes_id), \(field_valueTypes_name), \(field_valueTypes_dataType) FROM value_types"
                let rsMain: FMResultSet? = database.executeQuery(mainQuery, withArgumentsIn: [])
                while (rsMain!.next() == true) {
                    let id = rsMain?.string(forColumn: field_valueTypes_id)
                    let name = rsMain?.string(forColumn: field_valueTypes_name)
                    let data_type = rsMain?.string(forColumn: field_valueTypes_dataType)
                    print(" value_types.id: \(id!)\n value_types.name: \(name!)\n value_types.data_type: \(data_type!)")
                }
            }
        }
        database.close()
    }
    
    
    func selectLayersQuery() {
        if openDatabase() {
            do {
                let query = "SELECT \(field_layers_id), \(field_layers_name), \(field_layers_creationDate), \(field_layers_crypto), \(field_layers_cryptoKey), \(field_layers_md5Hash) FROM layers"
                let rsMain: FMResultSet? = database.executeQuery(query, withArgumentsIn: [])
                while (rsMain!.next() == true) {
                    let id = rsMain?.string(forColumn: field_layers_id)
                    let name = rsMain?.string(forColumn: field_layers_name)
                    let date = rsMain?.string(forColumn: field_layers_creationDate)
                    let crypto = rsMain?.string(forColumn: field_layers_crypto)
                    let cryptoKey = rsMain?.string(forColumn: field_layers_cryptoKey)
                    let md5Hash = rsMain?.string(forColumn: field_layers_md5Hash)
                    print(" layers.id: \(id!)\n layers.name: \(name!)\n layers.date: \(date!)\n layers.crypto: \(crypto!)\n layers.cryptoKey: \(cryptoKey!)\n layers.md5Hash: \(md5Hash!)")
                }
            }
        }
        database.close()
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
                }
            }
        }
        database.close()
        
    }
    
    //TODO This is not actually working... it checks if
    // the date is formatted correctly but allows things
    // like 89-67-2019
    func date_is_valid(strDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"
        let dateObj = dateFormatter.date(from: strDate)
        print("dateObj: \(dateObj)")
        return (dateObj != nil)
    }
    

    
    func addLayerType(attr: [String: String]) {
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
                    let query = "INSERT INTO layers (\(field_layers_name), \(field_layers_creationDate), \(field_layers_crypto), \(field_layers_cryptoKey), \(field_layers_md5Hash)) VALUES (\"\(attr[field_layers_name] ?? "")\", \"\(attr[field_layers_creationDate] ?? "")\", \"\(attr[field_layers_crypto] ?? "")\", \"\(attr[field_layers_cryptoKey] ?? "")\", \"\(attr[field_layers_md5Hash] ?? "")\");"
                    
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

}
