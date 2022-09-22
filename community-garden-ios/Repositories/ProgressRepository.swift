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
    
    init(){}
    
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
    
}
