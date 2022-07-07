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
    let progressRepo = ProgressRepository()
    let userDefaults = UserDefaultsService.shared
    
    var progressTable: Table {
        SQLiteDB.progress!
    }
    
    var statsTable: Table {
        SQLiteDB.statistics!
    }
    
    var nameColumn: Expression<String> {
        Expression<String>("name")
    }
    
    // Thresholds
    var STEPS_THRESHOLD: Double {
        Double(userDefaults.get(key: UserDefaultsKey.STEPS_GOAL) * 0.01)
    }
    
    init(){
        SQLiteDB.resetTableValues()
    }
    
    // MARK: Droplet methods
    
    func getNumDroplets() -> Stat? {
        let numDroplets = getStatistic("numDroplets")
        return numDroplets
    }
    
    func updateNumDroplets(value: Double){
        let numDropletsStat = getStatistic("numDroplets")
    
        if var numDroplets = numDropletsStat {
            numDroplets.value = Double(Int(numDroplets.value) + Int(value))
            SQLiteDB.updateColumn(table: statsTable, column: nameColumn, query: "numDroplets", update: numDroplets)
        }
    }
    
    // MARK: Update methods
    func updateStepsNumDroplets(value: Double){
        var progress: Progress = progressRepo.getStepProgress()
        
        // If there is a 1% difference, add droplets
        let progressDifference = value - progress.old
        if  progressDifference >= STEPS_THRESHOLD && STEPS_THRESHOLD > 0 {
            progress.old = value - (value.truncatingRemainder(dividingBy: STEPS_THRESHOLD))
            let dropletAddition = progressDifference / STEPS_THRESHOLD
            updateNumDroplets(value: dropletAddition)
        }
        progress.new = value


        SQLiteDB.insertUpdate(table: progressTable, name: TableName.progress, values: progress, onClonflictOf: nameColumn)
    }
    
    func updateWorkoutsNumDroplets(value: Double){
//        print("updating droplets workourts")
    }
    
    func updateWalkingRunningNumDroplets(value: Double){
//        print("updating droplets walkingRunning")
    }
    
    func updateSleepNumDroplets(value: Double){
//        print("updating droplets walkingRunning")
    }
    
    // MARK: Utility Methods
    func getStatistic(_ name: String) -> Stat? {
        let date = Expression<String>("name")
        let loadedData = SQLiteDB.getRowsByColumn(table: SQLiteDB.statistics, column: date, value: name, type: Stat.self)
        if loadedData.count > 0 {
            return loadedData[0]
        }
        return nil
    }
}
