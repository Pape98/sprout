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
    
    func insertUpdate<T: Codable>(table: Table, name: TableName, values: T){
        do {
            let conflictField = Expression<String>("date")
            try db!.run(table.upsert(values, onConflictOf: conflictField))
        } catch {
            print(error)
        }
    }
    
    func saveStepCount(value v: Double){
        let object = Step(date: today, count: v)
        insertUpdate(table: stepCounts!, name: TableName.stepCounts, values: object)
    }
    
    func saveWalkingRunningDistance(value v: Double){
        let object = WalkingRunningDistance(date: today, distance: v)
        insertUpdate(table: walkingRunningDistance!, name: TableName.walkingRunningDistance, values: object)
    }
    
    func saveWorkouts(value v: Double){
        let object = Workout(date: today, duration: v)
        insertUpdate(table: workouts!, name: TableName.workouts, values: object)
    }
    
    func saveSleep(value v: Double){
        let object = Sleep(date: today, duration: v)
        insertUpdate(table: sleep!, name: TableName.sleep, values: object)
    }
    
    func getTodayStepCount() {
        let value = Expression<Double>("value")
        let date = Expression<String>("date")
        var count = 0.0
        
        do {

            let counts = stepCounts!
                .select(value)
                .where(date == today)
                .limit(1)
            
            let all = Array(try db!.prepare(counts))
            print(all)

        } catch {
            print(error)
        }
        
    }
}
