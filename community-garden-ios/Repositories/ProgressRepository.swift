//
//  ProgressRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 06/07/2022.
//

import Foundation
import SQLite

class ProgressRepository {
    static let shared = ProgressRepository()
    let SQLiteDB = SQLiteService.shared
    
    var progressTable: Table {
        SQLiteDB.progress!
    }
    var column: Expression<String> {
        Expression<String>("name")
    }
    
    let type = Progress.self
    
    init(){
        // scheduleProgressReset()
    }
    
    // MARK: Get Progress Methods
    func getStepProgress() -> Progress {
        let progress = getProgress(DataOptions.steps)
        return progress
    }
    
    func getWalkingRunningProgress() -> Progress {
        return getProgress(DataOptions.walkingRunningDistance)
    }
    
    func getWorkoutsProgress() -> Progress {
        return getProgress(DataOptions.workouts)
    }
    
    func getSleepProgress() -> Progress {
        return getProgress(DataOptions.sleep)
    }
    
    func getProgress(_ data: DataOptions) -> Progress {
        return SQLiteDB.getRowsByColumn(table: progressTable, column: column, value: data.rawValue, type: type)[0]
    }
    
    
    // MARK: Utility methods
    func scheduleProgressReset(){
        var calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: Date.now)
        calendarDate.hour = 19
        calendarDate.minute = 30
        calendarDate.second = 0
        
        let date = Calendar.current.date(from: calendarDate)!
        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(resetProgress), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func resetProgress(){
        SQLiteDB.resetProgress(forceReset: true)
    }
}
