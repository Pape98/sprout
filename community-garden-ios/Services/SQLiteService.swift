//
//  SQLiteService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/21/22.
//

import Foundation
import SQLite

enum TableName: String {
    case StepCounts
    case WalkingRunningDistance
    case Sleep
    case Workouts
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
            
        } catch {
            print(error)
        }
    }
    
    func initTables(){
        stepCounts = createStepCountTable()
        walkingRunningDistance = createWalkingRunningDistanceTable()
        sleep = createSleepTable()
        workouts = createWorkoutsTable()
    }
    
    
    func createStepCountTable() -> Table? {
        let id = Expression<Int64>("id")
        let date = Expression<String>("date")
        let value = Expression<Double>("value")
        let stepCountTable = Table(TableName.StepCounts.rawValue)
        
        do {
            guard let connection = db else { return nil}
            try connection.run(stepCountTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(date, unique: true)
                t.column(value)
            })
            
        } catch {
            print(error)
        }
        return stepCountTable
    }
    
    func createWalkingRunningDistanceTable() -> Table? {
        let id = Expression<Int64>("id")
        let date = Expression<String>("date")
        let value = Expression<Double>("value")
        let walkingRunningDistanceTable = Table(TableName.WalkingRunningDistance.rawValue)
        
        do {
            guard let connection = db else { return nil}
            try connection.run(walkingRunningDistanceTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(date, unique: true)
                t.column(value)
            })
            
        } catch {
            print(error)
        }
        return walkingRunningDistanceTable
    }
    
    func createWorkoutsTable() -> Table? {
        let id = Expression<Int64>("id")
        let date = Expression<String>("date")
        let duration = Expression<Double>("duration")
        let workoutsTable = Table(TableName.Workouts.rawValue)
        
        do {
            guard let connection = db else { return nil}
            try connection.run(workoutsTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(date, unique: true)
                t.column(duration)
            })
            
        } catch {
            print(error)
        }
        
        return workoutsTable
    }
    
    func createSleepTable() -> Table? {
        let id = Expression<Int64>("id")
        let date = Expression<String>("date")
        let duration = Expression<Double>("duration")
        let sleepTable = Table(TableName.Sleep.rawValue)
        
        do {
            guard let connection = db else { return nil}
            try connection.run(sleepTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(date, unique: true)
                t.column(duration)
            })
            
        } catch {
            print(error)
        }
      
        return sleepTable
    }
    
    func insertUpdate(table: Table, name: TableName, values: Setter...){
        do {
            let conflictField = Expression<String>("date")
            try db!.run(table.upsert(values, onConflictOf: conflictField))
        } catch {
            print(error)
        }
    }
    
    func saveStepCount(value v: Double){
        let value = Expression<Double>("value")
        let date = Expression<String>("date")
        insertUpdate(table: stepCounts!, name: TableName.StepCounts, values: date <- today,value <- v)
    }
    
    func saveWalkingRunningDistance(value v: Double){
        let value = Expression<Double>("value")
        let date = Expression<String>("date")
        insertUpdate(table: walkingRunningDistance!, name: TableName.WalkingRunningDistance, values: date <- today,value <- v)
    }
    
    func saveWorkouts(value v: Double){
        let duration = Expression<Double>("duration")
        let date = Expression<String>("date")
        insertUpdate(table: workouts!, name: TableName.Workouts, values: date <- today, duration <- v)
    }
    
    func saveSleep(value v: Double){
        let duration = Expression<Double>("duration")
        let date = Expression<String>("date")
        insertUpdate(table: sleep!, name: TableName.Sleep, values: date <- today, duration <- v)
    }
    
    func getTodayStepCount() {
        let value = Expression<Double>("value")
        let date = Expression<String>("date")
        let res = stepCounts!.select(value)
                             .filter(date == today)
        
        print(res)
    }
}
