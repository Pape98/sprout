//
//  SQLiteRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 05/07/2022.
//

import Foundation

class HealthStoreRepository {
    
    let SQLiteDB = SQLiteService.shared
    let healthStoreService: HealthStoreService = HealthStoreService()
    static let shared = HealthStoreRepository()
    
    init() {
        healthStoreService.setUpAuthorization()
    }
    
    func getStepCounts() -> [Step]{
        return SQLiteDB.getStepCounts()
    }
    
    func getStepCountByDate(date: String) -> Step? {
        return SQLiteDB.getStepCountByDate(date: date)
    }
    
    func getWalkingRunningDistanceByDate(date: String) -> WalkingRunningDistance? {
        return SQLiteDB.getWalkingRunningDistanceByDate(date: date)
    }
    
    func getWorkoutByDate(date: String) -> Workout? {
        return SQLiteDB.getWorkoutByDate(date: date)
    }
    
    func getSleepByDate(date: String) -> Sleep? {
        return SQLiteDB.getSleepByDate(date: date)
    }
}
