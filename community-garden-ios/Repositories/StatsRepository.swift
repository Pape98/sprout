//
//  StatsRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 06/07/2022.
//

import Foundation
import SQLite

class StatsRepository {
    static let shared = StatsRepository()
    let SQLiteDB = SQLiteService.shared
    let userDefaults = UserDefaultsService.shared
    
    // User goals
    var stepsGoal: Float {
        userDefaults.get(key: UserDefaultsKey.STEPS_GOAL)
    }
    
    init(){
        SQLiteDB.resetStatistics()
    }
    
    func getNumDroplets() -> Stat? {
        do {
            let name = Expression<String>("name")
            let counts = SQLiteDB.statistics!.where(name == "numDroplets").limit(1)
            let loadedData: [Stat] = try SQLiteDB.db!.prepare(counts).map { row in
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
    
    func updateSleepNumDroplets(){
        print("updating droplets sleep")
    }
    
    func updateStepsNumDroplets(){
        let stepStat = getStatistic("name")
        print(stepStat)
    }
    
    func updateWorkoutsNumDroplets(){
        print("updating droplets workourts")
    }
    
    func updateWalkingRunningNumDroplets(){
        print("updating droplets walkingRunning")
    }
    
    func getStatistic(_ name: String) -> Stat? {
        do {
            let name = Expression<String>("name")
            let data = SQLiteDB.stepCounts!.where(name == name).limit(1)
            let loadedData: [Stat] = try SQLiteDB.db!.prepare(data).map { row in
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
    
    // Updates old and new
    func updateStatistic(_ name: String){
        
    }
}
