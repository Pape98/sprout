//
//  SQLiteService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/21/22.
//

import Foundation
import SQLite

enum TableName: String {
    case stepCounts
    case walkingRunningDistance
    case sleep
    case workouts
    case statistics
    case progress
}

enum Statistic: String {
    case numDroplets
}

class SQLiteService {
    
    // MARK: Properties
    var db: Connection?
    static let shared = SQLiteService()
    
    // Tables
    var stepCounts: Table?
    var walkingRunningDistance: Table?
    var sleep: Table?
    var workouts: Table?
    var statistics: Table?
    var progress: Table?
    
    // Others
    let today = Date.today
    
    init(){
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            // 1. Initialize database
            db = try Connection("\(path)/communityGarden.sqlite3")
            // 2. Initialize database tabes
            initTables()
            resetTableValues()
            
        } catch {
            print(error)
        }
    }
    
    // MARK: Database table initializations
    func initTables(){
        statistics = createStatisticsTable()
        progress = createProgressTable()
    }
    
    func createProgressTable() -> Table? {
        let id = Expression<String>("id")
        let name = Expression<String>("name")
        let new = Expression<Double>("new")
        let old = Expression<Double>("old")
        let progressTable = Table(TableName.progress.rawValue)
        
        do {
            guard let connection = db else { return nil }
            try connection.run(progressTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name, unique: true)
                t.column(new)
                t.column(old)
            })
            
        } catch {
            Debug.log.error(error)
        }
        return progressTable
    }
    
    func createStatisticsTable() -> Table? {
        let id = Expression<String>("id")
        let name = Expression<String>("name")
        let value = Expression<Double>("value")
        let statsTable = Table(TableName.statistics.rawValue)
        
        do {
            guard let connection = db else { return nil }
            try connection.run(statsTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name, unique: true)
                t.column(value)
            })
            
        } catch {
            print("createStatisticsTable()",error)
            Debug.log.error("createStatisticsTable()",error)
        }
        return statsTable
    }
    
    // MARK: Table values initialization
    func resetTableValues(forceReset: Bool = false){
        resetStatistics(forceReset: forceReset)
        resetProgress(forceReset: forceReset)
    }
    
    
    func resetStatistics(forceReset: Bool = false){
        
        guard statistics != nil else { return }
        
        for name in Statistics.list {
            // Check if fields already exist
            if doesExist(table: statistics!, column: Expression<String>("name"), value: name) == true && forceReset == false { continue }
            let stat = Stat(name: name)
            insertUpdate(table: statistics!, name: TableName.statistics, values: stat, onClonflictOf: Expression<String>("name"))
        }
    }
    
    func resetProgress(forceReset: Bool = false){
        
        guard progress != nil else { return }
        
        for name in DataOptions.dalatList {
            // Check if fields already exist
            if doesExist(table: progress!, column: Expression<String>("name"), value: name) == true && forceReset == false { continue }
            
            let progressObject = Progress(name: name)
            insertUpdate(table: progress!, name: TableName.progress, values: progressObject, onClonflictOf: Expression<String>("name"))
        }
    }
        
    // MARK: Utitlies
    func insertUpdate<T: Codable>(table: Table, name: TableName, values: T, onClonflictOf: Expression<String>){
        do {
            try db!.run(table.upsert(values, onConflictOf: onClonflictOf))
        } catch {
            Debug.log.error("insertUpdate()",error)
        }
    }
    
    func doesExist(table:Table?, column: Expression<String>, value: String) -> Bool {
        do {
            let query = table!.where(column == value)
            let data = try db!.prepare(query).map { row in
                row
            }
            
            if data.count == 0 {
                return false
            }
            
        } catch {
            Debug.log.error("doesExist()",error)
        }
        return true
    }
    
    func getRowsByColumn<T: Codable>(table: Table?, column: Expression<String>, value: String, type: T.Type) -> [T]{
        do {
            let query = table!.where(column == value)
            let loadedData: [T] = try db!.prepare(query).map { row in
                return try row.decode()
            }
            
            return loadedData
            
        } catch {
            Debug.log.error(error)
        }
        return []
    }
    
    func updateColumn(table: Table?, column: Expression<String>, query: String, update: Codable){
        let query = table!.where(column == query)
        do {
            try db!.run(query.update(update))
        } catch {
            Debug.log.error("updateColumn",error)
        }
    }
}
