//
//  SQLiteRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 05/07/2022.
//

import Foundation
import SQLite

class HealthStoreSQLRepository {
    
    let SQLiteDB = SQLiteService.shared
    let healthStoreService: HealthStoreService = HealthStoreService()
    static let shared = HealthStoreRepository()
    
    init() {
        healthStoreService.setUpAuthorization()
    }
    
    
    func getStepCountByDate(date query: String) -> Step? {
        
        let date = Expression<String>("date")
        let loadedData = SQLiteDB.getRowsByColumn(table: SQLiteDB.stepCounts, column: date, value: query, type: Step.self)
        if loadedData.count > 0 {
            return loadedData[0]
        }
        return nil
    }
    
    func getWalkingRunningDistanceByDate(date query: String) -> WalkingRunningDistance? {
        let date = Expression<String>("date")
        let loadedData = SQLiteDB.getRowsByColumn(table: SQLiteDB.walkingRunningDistance, column: date, value: query, type: WalkingRunningDistance.self)
        if loadedData.count > 0 {
            return loadedData[0]
        }
        return nil
    }
    
    func getWorkoutByDate(date query: String) -> Workout? {
        let date = Expression<String>("date")
        let loadedData = SQLiteDB.getRowsByColumn(table: SQLiteDB.workouts, column: date, value: query, type: Workout.self)
        if loadedData.count > 0 {
            return loadedData[0]
        }
        return nil
    }
    
    func getSleepByDate(date query: String) -> Sleep? {
        let date = Expression<String>("date")
        let loadedData = SQLiteDB.getRowsByColumn(table: SQLiteDB.sleep, column: date, value: query, type: Sleep.self)
        if loadedData.count > 0 {
            return loadedData[0]
        }
        return nil
    }
}
