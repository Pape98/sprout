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
    
    // SQLite Service variables
    var progressTable: Table {
        SQLiteDB.progress!
    }
    
    var statsTable: Table {
        SQLiteDB.statistics!
    }
    
    var nameColumn: Expression<String> {
        Expression<String>("name")
    }

    
    // Default Settings
    var mapping: [String: String]? {
        let mappedData:[String: Any]? = userDefaults.get(key: UserDefaultsKey.MAPPED_DATA) // ["Tree": "Steps"]
        if let convertedData = mappedData as? [String: String] {
            let swappedData = convertedData.swapKeyValues() // ["Steps":"Tree"]
            return swappedData
        }
        return nil
    }
    var statUpdateCallbacks: [String: ((Double) -> Void)] {
        [
            "Flower": updateNumSeeds,
            "Tree": updateNumDroplets
        ]
    }
    
    init(){
        SQLiteDB.resetTableValues()
    }
    
    // MARK: Droplet & Seed methods
    
    func getNumDroplets() -> Stat? {
        return getStatistic(Statistics.numDroplets.rawValue)
    }
    
    func getNumSeeds() -> Stat? {
        return getStatistic(Statistics.numSeeds.rawValue)
    }
    
    func updateNumDroplets(_ value: Double){
        updateStatistic(name: Statistics.numDroplets, value: value)
    }
    
    func updateNumSeeds(_ value: Double){
        updateStatistic(name: Statistics.numSeeds, value: value)
    }
    
    
    // MARK: Update methods
    func stepsChangeCallback(value: Double){
        // Check if user is tracking data
        guard let mapping = mapping else { return }
        guard mapping[DataOptions.steps.rawValue] != nil else { return }
        
        // Update progress
        let threshold = Double(userDefaults.get(key: UserDefaultsKey.STEPS_GOAL) * 0.01)
        let progress: Progress = progressRepo.getStepProgress()
        updateProgress(data: DataOptions.steps, value: value, progress: progress, threshold: threshold)
    }
    
    func workoutsChangeCallback(value: Double){
        // TODO: Finish implementation
    }
    
    func walkingRunningChangeCallback(value: Double){
        // Check if user is tracking data
        guard let mapping = mapping else { return }
        guard mapping[DataOptions.steps.rawValue] != nil else { return }
        // Update progress
        let threshold = Double(userDefaults.get(key: UserDefaultsKey.WALKING_RUNNING_GOAL) * 0.1)
        let progress: Progress = progressRepo.getWalkingRunningProgress()
        updateProgress(data: DataOptions.walkingRunningDistance, value: value, progress: progress, threshold: threshold)
    }
    
    func sleepChangeCallback(value: Double){
        // TODO: Finish implementation
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
    
    func updateStatistic(name: Statistics, value: Double) {
        let stat = getStatistic(name.rawValue)
        if var stat = stat {
            stat.value = Double(Int(stat.value) + Int(value))
            SQLiteDB.updateColumn(table: statsTable, column: nameColumn, query: name.rawValue, update: stat)
        }
    }
    
    func getStatUpdateCallback(data: DataOptions) -> (_: Double) -> Void {
        if mapping![data.rawValue] == "Flower" {
            return updateNumDroplets
        } else {
            return updateNumSeeds
        }
    }
    
    func updateProgress(data: DataOptions, value: Double, progress: Progress, threshold: Double){
        var progress = progress
        let progressDifference = value - progress.old
        
        if  progressDifference >= threshold && threshold > 0 {
            progress.old = value - (value.truncatingRemainder(dividingBy: threshold))
            let statAddition = progressDifference / threshold
            print(statAddition)
            guard let updateCallback: ((Double) -> Void) = statUpdateCallbacks[mapping![data.rawValue]!] else { return }
            updateCallback(statAddition)
        }
        progress.new = value
        
        SQLiteDB.insertUpdate(table: progressTable, name: TableName.progress, values: progress, onClonflictOf: nameColumn)
    }
}
