//
//  SQLiteRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 05/07/2022.
//

import Foundation

class HealthStoreRepository {
    
    let SQLiteDB = SQLiteService.shared
    let today = Date.now.getFormattedDate(format: "MM-dd-yyyy")
    let healthStoreService: HealthStoreService = HealthStoreService()
    static let shared = HealthStoreRepository()
    
    init() {
        healthStoreService.setUpAuthorization()
    }
    
    func getTodayStepCount(){
        SQLiteDB.getTodayStepCount()
    }
}
