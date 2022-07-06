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
    
    func getStepProgress() -> Progress {
        return SQLiteDB.getRowsByColumn(table: progressTable, column: column, value: "steps", type: type)[0]
    }
    
}
