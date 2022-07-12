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
    let today = Date.now.getFormattedDate(format: "MM-dd-yyyy")
    
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
//        stepCounts = createStepCountTable()
//        walkingRunningDistance = createWalkingRunningDistanceTable()
//        sleep = createSleepTable()
//        workouts = createWorkoutsTable()
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
            print(error)
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
        }
        return statsTable
    }
    
//    func createStepCountTable() -> Table? {
//        let id = Expression<String>("id")
//        let date = Expression<String>("date")
//        let count = Expression<Double>("count")
//        let stepCountTable = Table(TableName.stepCounts.rawValue)
//
//        do {
//            guard let connection = db else { return nil}
//            try connection.run(stepCountTable.create(ifNotExists: true) { t in
//                t.column(id, primaryKey: true)
//                t.column(date, unique: true)
//                t.column(count)
//            })
//
//        } catch {
//            print("createStepCountTable()", error)
//        }
//        return stepCountTable
//    }
    
//    func createWalkingRunningDistanceTable() -> Table? {
//        let id = Expression<String>("id")
//        let date = Expression<String>("date")
//        let distance = Expression<Double>("distance")
//        let walkingRunningDistanceTable = Table(TableName.walkingRunningDistance.rawValue)
//
//        do {
//            guard let connection = db else { return nil}
//            try connection.run(walkingRunningDistanceTable.create(ifNotExists: true) { t in
//                t.column(id, primaryKey: true)
//                t.column(date, unique: true)
//                t.column(distance)
//            })
//
//        } catch {
//            print("createWalkingRunningDistanceTable()",error)
//        }
//        return walkingRunningDistanceTable
//    }
    
//    func createWorkoutsTable() -> Table? {
//        let id = Expression<String>("id")
//        let date = Expression<String>("date")
//        let duration = Expression<Double>("duration")
//        let workoutsTable = Table(TableName.workouts.rawValue)
//
//        do {
//            guard let connection = db else { return nil}
//            try connection.run(workoutsTable.create(ifNotExists: true) { t in
//                t.column(id, primaryKey: true)
//                t.column(date, unique: true)
//                t.column(duration)
//            })
//
//        } catch {
//            print("createWorkoutsTable()",error)
//        }
//
//        return workoutsTable
//    }
    
//    func createSleepTable() -> Table? {
//        let id = Expression<String>("id")
//        let date = Expression<String>("date")
//        let duration = Expression<Double>("duration")
//        let sleepTable = Table(TableName.sleep.rawValue)
//
//        do {
//            guard let connection = db else { return nil}
//            try connection.run(sleepTable.create(ifNotExists: true) { t in
//                t.column(id, primaryKey: true)
//                t.column(date, unique: true)
//                t.column(duration)
//            })
//
//        } catch {
//            print("createSleepTable()",error)
//        }
//
//        return sleepTable
//    }
    
    
    // MARK: Table values initialization
    func resetTableValues(){
        resetStatistics()
        resetProgress()
    }
    
    func resetStatistics(forceReset: Bool = false){
        
        guard statistics != nil else { return }
        
        for name in Statistics.list {
            // Check if fields already exist
            if doesExist(table: statistics!, column: Expression<String>("name"), value: name) == true {
                continue
            }
            let stat = Stat(name: name)
            insertUpdate(table: statistics!, name: TableName.statistics, values: stat, onClonflictOf: Expression<String>("name"))
        }
    }
    
    func resetProgress(forceReset: Bool = false){
        
        guard progress != nil else { return }
        
        for name in DataOptions.dalatList {
            // Check if fields already exist
            if doesExist(table: progress!, column: Expression<String>("name"), value: name) == true && forceReset == false {
                continue
            }
            
            let progressObject = Progress(name: name)
            insertUpdate(table: progress!, name: TableName.progress, values: progressObject, onClonflictOf: Expression<String>("name"))
        }
    }
    
    // MARK: Saving data to tables
//    func saveStepCount(value v: Double){
//        let object = Step(date: today, count: v)
//        insertUpdate(table: stepCounts!, name: TableName.stepCounts, values: object, onClonflictOf: Expression<String>("date"))
//        NotificationSender.send(type: NotificationType.FetchStepCount.rawValue, message: v)
//    }
//
//    func saveWalkingRunningDistance(value v: Double){
//        let object = WalkingRunningDistance(date: today, distance: v)
//        insertUpdate(table: walkingRunningDistance!, name: TableName.walkingRunningDistance, values: object, onClonflictOf: Expression<String>("date"))
//        NotificationSender.send(type: NotificationType.FetchWalkingRunningDistance.rawValue, message: v)
//    }
//
//    func saveWorkouts(value v: Double){
//        let object = Workout(date: today, duration: v)
//        insertUpdate(table: workouts!, name: TableName.workouts, values: object, onClonflictOf: Expression<String>("date"))
//        NotificationSender.send(type: NotificationType.FetchWorkout.rawValue, message: v)
//    }
//
//    func saveSleep(value v: Double){
//        let object = Sleep(date: today, duration: v)
//        insertUpdate(table: sleep!, name: TableName.sleep, values: object, onClonflictOf: Expression<String>("date"))
//        NotificationSender.send(type: NotificationType.FetchSleep.rawValue, message: v)
//    }
    
    // MARK: Utitlies
    func insertUpdate<T: Codable>(table: Table, name: TableName, values: T, onClonflictOf: Expression<String>){
        do {
            try db!.run(table.upsert(values, onConflictOf: onClonflictOf))
        } catch {
            print("insertUpdate()",error)
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
            print("doesExist()",error)
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
            print(error)
        }
        return []
    }
    
    func updateColumn(table: Table?, column: Expression<String>, query: String, update: Codable){
        let query = table!.where(column == query)
        do {
            try db!.run(query.update(update))
        } catch {
            print("updateColumn",error)
        }
    }
}
