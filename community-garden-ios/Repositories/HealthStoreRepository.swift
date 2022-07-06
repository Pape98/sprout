//
//  SQLiteRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 05/07/2022.
//

import Foundation
import SQLite

class HealthStoreRepository {
    
    let SQLiteDB = SQLiteService.shared
    let healthStoreService: HealthStoreService = HealthStoreService()
    static let shared = HealthStoreRepository()
    
    init() {
        healthStoreService.setUpAuthorization()
    }
    
    
    func getStepCounts() -> [Step] {
        do {
            let counts = SQLiteDB.stepCounts!
            let loadedCounts: [Step] = try SQLiteDB.db!.prepare(counts).map { row in
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
            let counts = SQLiteDB.stepCounts!.where(date == query).limit(1)
            let loadedData: [Step] = try SQLiteDB.db!.prepare(counts).map { row in
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
            let distances = SQLiteDB.walkingRunningDistance!.where(date == query).limit(1)
            let loadedData: [WalkingRunningDistance] = try SQLiteDB.db!.prepare(distances).map { row in
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
            let durations = SQLiteDB.workouts!.where(date == query).limit(1)
            let loadedData: [Workout] = try SQLiteDB.db!.prepare(durations).map { row in
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
            let durations = SQLiteDB.sleep!.where(date == query).limit(1)
            let loadedData: [Sleep] = try SQLiteDB.db!.prepare(durations).map { row in
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
