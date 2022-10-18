//
//  StatsRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 06/07/2022.
//

import Foundation
import SQLite

class StatsSQLRepository {
    static let shared = StatsSQLRepository()
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
    var statUpdateCallbacks: [String: ((Double) -> Void)] {
        [
            "Flower": updateNumSeeds,
            "Tree": updateNumDroplets
        ]
    }
    
    init(){}
    
    
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
        
        guard let settings = UserService.shared.user.settings else {  return }
                
        // Check if user is tracking data
        if !settings.data.contains(DataOptions.steps.rawValue) { return }
        
        // Update progress
        let stepGoal = settings.stepsGoal
        guard let stepGoal = stepGoal else { return}

        let threshold =  Double(stepGoal) * getPercentage(key: DataOptions.steps)
        let progress: Progress = progressRepo.getStepProgress()
    
        updateProgress(data: DataOptions.steps, value: value, progress: progress, threshold: threshold)
    }
    
    func workoutsChangeCallback(value: Double){
        guard let settings = UserService.shared.user.settings else {  return }
        
        // Check if user is tracking data
        if !settings.data.contains(DataOptions.workouts.rawValue) { return }
                
        // Update progress
        let workoutsGoal = settings.workoutsGoal
        guard let workoutsGoal = workoutsGoal else { return}

        let threshold =  Double(workoutsGoal) * getPercentage(key: DataOptions.workouts)
        let progress: Progress = progressRepo.getWorkoutsProgress()

        updateProgress(data: DataOptions.workouts, value: value, progress: progress, threshold: threshold)
    }
    
    func walkingRunningChangeCallback(value: Double){
        guard let settings = UserService.shared.user.settings else {  return }
        
        // Check if user is tracking data
        if !settings.data.contains(DataOptions.walkingRunningDistance.rawValue) { return }
        
        // Update progress
        let walkingRunningGoal = settings.walkingRunningGoal
        guard let walkingRunningGoal = walkingRunningGoal else { return}
        let threshold = Double(walkingRunningGoal) * getPercentage(key: DataOptions.walkingRunningDistance)
        let progress: Progress = progressRepo.getWalkingRunningProgress()

        updateProgress(data: DataOptions.walkingRunningDistance, value: value, progress: progress, threshold: threshold)
    }
    
    func sleepChangeCallback(value: Double){
        guard let settings = UserService.shared.user.settings else {  return }
        // Check if user is tracking data
        if !settings.data.contains(DataOptions.sleep.rawValue) { return }
        
        // Update progress
        let sleepGoal = settings.sleepGoal
        guard let sleepGoal = sleepGoal else { return }
        let threshold =  Double(sleepGoal) * 60 * getPercentage(key: DataOptions.sleep)
        let progress: Progress = progressRepo.getSleepProgress()
  
        updateProgress(data: DataOptions.sleep, value: value, progress: progress, threshold: threshold)
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
    
    func updateProgress(data: DataOptions, value: Double, progress: Progress, threshold: Double){
        var progress = progress
        let progressDifference = value - progress.old
        
        // Get callback function
        let mappedData = UserService.shared.user.settings!.mappedData.swapKeyValues() // ["Steps": "Tree"]
        
        guard let element = mappedData[data.rawValue] else { return }
        let mappedElement = element // "Tree"
        
        if  progressDifference >= threshold && threshold > 0 {
            
            progress.old = value - (value.truncatingRemainder(dividingBy: threshold))
            let statAddition = progressDifference / threshold
            
            guard let updateCallback: ((Double) -> Void) = statUpdateCallbacks[mappedElement] else { return }
            
            // Play win sound
            AudioPlayer.shared.playCustomSound(filename: "win", volume: 0.5)
            AppViewModel.shared.alertPointsGained(mappedElement: mappedElement, value: statAddition)
            
            updateCallback(statAddition)
            
            // Analytics
            let addition = Int(statAddition)
            if mappedElement == "Tree"{
                SproutAnalytics.shared.gainingDroplets(numDroplet: addition)
            } else {
                SproutAnalytics.shared.gainingSseeds(numSeed: addition)
            }
        }
        progress.new = value
        
        SQLiteDB.insertUpdate(table: progressTable, name: TableName.progress, values: progress, onClonflictOf: nameColumn)
    }
    
    func getPercentage(key: DataOptions) -> Double {
        let percentages = RemoteConfiguration.shared.getPercentages()
        guard let percentages = percentages else { return 0 }
        return percentages[key.rawValue]! as! Double
    }
}
