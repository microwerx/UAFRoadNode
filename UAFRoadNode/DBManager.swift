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
    let field_valueTypes_DataType = "data_type"
    
    let field_units_id = "id"
    let field_units_name = "name"
    let field_units_valueTypeID = "value_type_id"
    
    let field_nodes_id = "id"
    let field_nodes_name = "name"
    let field_nodes_lat = "latitude"
    let field_nodes_long = "longitude"
    let field_nodes_layerName = "layer_name"
    
    let field_attributes_id = "id"
    let field_attributes_name = "name"
    let field_attributes_layerName = "layer_name"
    let field_attributes_unitID = "unit_id"
    
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
     
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
     
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    let createLayersTableQuery = "CREATE TABLE layers (\(field_layers_id) INTEGER AUTOINCREMENT, \(field_layers_name) VARCHAR(45) NOT NULL, \(field_layers_creationDate) DATETIME not null, \(field_layers_crypto) VARCHAR(45), \(field_layers_cryptoKey) VARCHAR(45), \(field_layers_md5Hash) VARCHAR(45), PRIMARY KEY (\(field_layers_id), UNIQUE (\(field_layers_name)));"
                    
                    let createValueTypesTable = "CREATE TABLE value_type (\(field_valueTypes_id) INTEGER AUTOINCREMENT, \(field_valueTypes_name) VARCHAR(45) NOT NULL, \(field_valueTypes_DataType) VARCHAR(45) NOT NULL, PRIMARY KEY (\(field_valueTypes_id)), UNIQUE (\(field_valueTypes_name)));"
                    
                    let createUnitsTableQuery = "CREATE TABLE units (\(field_units_id) INTEGER AUTOINCREMENT, \(field_units_name) VARCHAR(45) NOT NULL, PRIMARY KEY (\(field_units_id)), FOREIGN KEY (\(field_units_valueTypeID)) REFERENCES value_type(\(field_valueTypes_id)), UNIQUE (\(field_units_name)));"
                    
                    let createNodesTableQuery = "CREATE TABLE nodes (\(field_nodes_id) INTEGER AUTOINCREMENT, \(field_nodes_name) VARCHAR(45) NOT NULL, \(field_nodes_lat) DECIMAL(9, 6) NOT NULL, \(field_nodes_long) DECIMAL(9, 6) NOT NULL, PRIMARY KEY (\(field_nodes_id), FOREIGN KEY (\(field_nodes_layerName)) REFERENCES layers(\(field_layers_name));"
                    
                    let createAttributesTableQuery = "CREATE TABLE attributes (\(field_attributes_id) INTEGER AUTOINCREMENT, \(field_attributes_name) VARCHAR(45) NOT NULL, PRIMARY KEY (\(field_attributes_id)), FOREIGN KEY (\(field_attributes_layerName) REFERENCES layers(\(field_layers_name), FOREIGN KEY (\(field_attributes_unitID)) REFERENCES units(\(field_units_id)));"
                    
                    let createDataTableQuery = "CREATE TABLE data (\(field_data_id) INTEGER AUTOINCREMENT, \(field_data_integerValue) INTEGER, \(field_data_textValue) TEXT, \(field_data_real_value) REAL, \(field_data_numeric_value) NUMERIC, \(field_data_dateTimeAdded) DATETIME NOT NULL, PRIMARY KEY (\(field_data_id)), FOREIGN KEY (\(field_data_attrID)) REFERENCES attributes(\(field_attributes_id)), FOREIGN KEY (\(field_data_nodeID)) REFERENCES nodes(\(field_nodes_id)));"
                    
                    let create_table_queries: [String] = [createLayersTableQuery, createValueTypesTable, createUnitsTableQuery, createNodesTableQuery, createAttributesTableQuery, createDataTableQuery]

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
    
    
    func insertIntoLayerTable() {
        // Open the database.
        var query = ""
        if openDatabase() {
            query += "INSERT INTO layers (\(field_layers_name), \(field_layers_creationDate), \(field_layers_crypto), \(field_layers_cryptoKey), \(field_layers_md5Hash)) VALUES ('test', 103019, 'crypto', 'cryptokey', gg34hj5g3jh4g5hj3g4jh5g);"
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
}
