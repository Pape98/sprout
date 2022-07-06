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
        stepCounts = createStepCountTable()
        walkingRunningDistance = createWalkingRunningDistanceTable()
        sleep = createSleepTable()
        workouts = createWorkoutsTable()
        statistics = createStatisticsTable()
    }
    
    func resetTableValues(){
        resetStatistics()
    }
    
//    func createProgressTable(){
//        let id = Expression<String>("id")
//        let name = Expression<String>("name")
//        let newValue = Expression<Double>("new")
//        let oldValue = Expression<Double>("oldValue")
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
//            print(error)
//        }
//        return stepCountTable
//    }
    
    func createStepCountTable() -> Table? {
        let id = Expression<String>("id")
        let date = Expression<String>("date")
        let count = Expression<Double>("count")
        let stepCountTable = Table(TableName.stepCounts.rawValue)
        
        do {
            guard let connection = db else { return nil}
            try connection.run(stepCountTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(date, unique: true)
                t.column(count)
            })
            
        } catch {
            print(error)
        }
        return stepCountTable
    }
    
    func createWalkingRunningDistanceTable() -> Table? {
        let id = Expression<String>("id")
        let date = Expression<String>("date")
        let distance = Expression<Double>("distance")
        let walkingRunningDistanceTable = Table(TableName.walkingRunningDistance.rawValue)
        
        do {
            guard let connection = db else { return nil}
            try connection.run(walkingRunningDistanceTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(date, unique: true)
                t.column(distance)
            })
            
        } catch {
            print(error)
        }
        return walkingRunningDistanceTable
    }
    
    func createWorkoutsTable() -> Table? {
        let id = Expression<String>("id")
        let date = Expression<String>("date")
        let duration = Expression<Double>("duration")
        let workoutsTable = Table(TableName.workouts.rawValue)
        
        do {
            guard let connection = db else { return nil}
            try connection.run(workoutsTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(date, unique: true)
                t.column(duration)
            })
            
        } catch {
            print(error)
        }
        
        return workoutsTable
    }
    
    func createSleepTable() -> Table? {
        let id = Expression<String>("id")
        let date = Expression<String>("date")
        let duration = Expression<Double>("duration")
        let sleepTable = Table(TableName.sleep.rawValue)
        
        do {
            guard let connection = db else { return nil}
            try connection.run(sleepTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(date, unique: true)
                t.column(duration)
            })
            
        } catch {
            print(error)
        }
        
        return sleepTable
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
            print(error)
        }
        return statsTable
    }
    
    // MARK: Table values initialization
    func resetStatistics(){
        
        // Check if fields already exist
        if doesExist(table: statistics!, column: Expression<String>("name"), value: "numDroplets") == true {
            return
        }
        let stat = Stat(name: "numDroplets")
        guard statistics != nil else { return }
        insertUpdate(table: statistics!, name: TableName.statistics, values: stat, onClonflictOf: Expression<String>("name"))
    }
    
    // MARK: Saving data to tables
    func saveStepCount(value v: Double){
        let object = Step(date: today, count: v)
        insertUpdate(table: stepCounts!, name: TableName.stepCounts, values: object, onClonflictOf: Expression<String>("date"))
        NotificationSender.send(type: NotificationType.FetchStepCount.rawValue)
    }
    
    func saveWalkingRunningDistance(value v: Double){
        let object = WalkingRunningDistance(date: today, distance: v)
        insertUpdate(table: walkingRunningDistance!, name: TableName.walkingRunningDistance, values: object, onClonflictOf: Expression<String>("date"))
        NotificationSender.send(type: NotificationType.FetchWalkingRunningDistance.rawValue)
    }
    
    func saveWorkouts(value v: Double){
        let object = Workout(date: today, duration: v)
        insertUpdate(table: workouts!, name: TableName.workouts, values: object, onClonflictOf: Expression<String>("date"))
        NotificationSender.send(type: NotificationType.FetchWorkout.rawValue)
    }
    
    func saveSleep(value v: Double){
        let object = Sleep(date: today, duration: v)
        insertUpdate(table: sleep!, name: TableName.sleep, values: object, onClonflictOf: Expression<String>("date"))
        print("updating sleep sqlite")
        NotificationSender.send(type: NotificationType.FetchSleep.rawValue)
    }
    
    // MARK: Utitlies
    func insertUpdate<T: Codable>(table: Table, name: TableName, values: T, onClonflictOf: Expression<String>){
        do {
            try db!.run(table.upsert(values, onConflictOf: onClonflictOf))
        } catch {
            print(error)
        }
    }
    
    func doesExist(table:Table?, column: Expression<String>, value: String) -> Bool {
        do {
            let table = table!
            let tableValues: [Step] = try db!.prepare(table).map { row in
                return try row.decode()
            }
            
            if tableValues.isEmpty {
                return false }
            
        } catch {
            print(error)
        }
        return true
    }
}
