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
    
    // MARK: Database table initializations
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
    
    
    // MARK: Saving data to tables
    
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
        NotificationSender.send(type: NotificationType.FetchStepCount.rawValue)
    }
    
    func saveWalkingRunningDistance(value v: Double){
        let object = WalkingRunningDistance(date: today, distance: v)
        insertUpdate(table: walkingRunningDistance!, name: TableName.walkingRunningDistance, values: object)
        NotificationSender.send(type: NotificationType.FetchWalkingRunningDistance.rawValue)
    }
    
    func saveWorkouts(value v: Double){
        let object = Workout(date: today, duration: v)
        insertUpdate(table: workouts!, name: TableName.workouts, values: object)
        NotificationSender.send(type: NotificationType.FetchWorkout.rawValue)
    }
    
    func saveSleep(value v: Double){
        let object = Sleep(date: today, duration: v)
        insertUpdate(table: sleep!, name: TableName.sleep, values: object)
        NotificationSender.send(type: NotificationType.FetchSleep.rawValue)
    }
    
    // MARK: Data retrieval
    func getStepCounts() -> [Step] {
        
        do {
            
            let counts = stepCounts!
            let loadedCounts: [Step] = try db!.prepare(counts).map { row in
                return try row.decode()
            }
            
            return loadedCounts
            
        } catch {
            print(error)
        }
        return []
    }
    
    func getStepCountByDate(date query: String) -> Step? {
        
        do {
            let date = Expression<String>("date")
            let counts = stepCounts!.where(date == query).limit(1)
            let loadedData: [Step] = try db!.prepare(counts).map { row in
                return try row.decode()
            }
            
            if loadedData.count > 0 {
                return loadedData[0]
            }
            
        } catch {
            print(error)
        }
        return nil
    }
    
    func getWalkingRunningDistanceByDate(date query: String) -> WalkingRunningDistance? {
        
        do {
            let date = Expression<String>("date")
            let distances = walkingRunningDistance!.where(date == query).limit(1)
            let loadedData: [WalkingRunningDistance] = try db!.prepare(distances).map { row in
                return try row.decode()
            }
                
            if loadedData.count > 0 {
                return loadedData[0]
            }
            
        } catch {
            print(error)
        }
        return nil
    }
    
    func getWorkoutByDate(date query: String) -> Workout? {
        
        do {
            let date = Expression<String>("date")
            let durations = workouts!.where(date == query).limit(1)
            let loadedData: [Workout] = try db!.prepare(durations).map { row in
                return try row.decode()
            }
                
            if loadedData.count > 0 {
                return loadedData[0]
            }
            
        } catch {
            print(error)
        }
        return nil
    }
    
    func getSleepByDate(date query: String) -> Sleep? {
        
        do {
            let date = Expression<String>("date")
            let durations = sleep!.where(date == query).limit(1)
            let loadedData: [Sleep] = try db!.prepare(durations).map { row in
                return try row.decode()
            }
                
            if loadedData.count > 0 {
                return loadedData[0]
            }
            
        } catch {
            print(error)
        }
        return nil
    }
}
