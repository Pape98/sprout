//
//  SQLiteService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/21/22.
//

import Foundation
import SQLite

enum TableName: String {
    case DataSummary
}

class SQLiteService {
    
    // MARK: Properties
    var db: Connection?
    static let shared = SQLiteService()
    var dataSummary: Table?
    
    var onConflictFields: [String: Expressible] = [:]
    
    init(){
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            // 1. Initialize database
            db = try Connection("\(path)/communityGarden.sqlite3")
            // 2. Initialize database tabes
            initTables()
            
        } catch {
            print(error)
        }
    }
    
    func initTables(){
        dataSummary = createDataSummaryTable()
    }
    
    
    func createDataSummaryTable() -> Table? {
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        let value = Expression<Double>("value")
        let dataSummaryTable = Table(TableName.DataSummary.rawValue)
        
        do {
            
            guard let connection = db else { return nil}
            try connection.run(dataSummaryTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name, unique: true)
                t.column(value)
            })
            
        } catch {
            print(error)
        }
        onConflictFields[TableName.DataSummary.rawValue] = name
        return dataSummaryTable
    }
    
    func insertUpdate(table: Table, name: TableName, values: Setter...){
        do {
            let conflictField = onConflictFields[name.rawValue]!
            try db!.run(table.upsert(values, onConflictOf: conflictField))
        } catch {
            print(error)
        }
    }
    
    func saveStepCount(value v: Double){
        let value = Expression<Double>("value")
        let name = Expression<String>("name")
        insertUpdate(table: dataSummary!, name: TableName.DataSummary, values: name <- "stepCount",  value <- v)
    }
    
    func saveWalkingRunningDistance(value v: Double){
        let value = Expression<Double>("value")
        let name = Expression<String>("name")
        insertUpdate(table: dataSummary!, name: TableName.DataSummary, values: name <- "walkingRunningDistance",  value <- v)
    }
}
