//
//  SQLiteService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/21/22.
//

import Foundation
import SQLite3

class SQLiteService {
    
    // MARK: Properties
    var db: OpaquePointer?
    var path: String = "communityGarden.sqlite"
    
    init() {
        self.db = createDB()
    }
    
    // MARK: Methods
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("ERROR: creating DB")
            return nil
        } else {
            print("Database has been created with path \(path)")
            return db
        }
    }
    
//    func createStepTable() {
//        let query = "CREATE IF NOT EXISTS step(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, count"
//    }
}
