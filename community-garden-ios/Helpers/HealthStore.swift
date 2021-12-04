//
//  HealthStore.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import Foundation
import HealthKit

class HealthStore {
    
    // Provides all functionalities related health data
    var healthStore: HKHealthStore?
    
    init() {
        // Check if health data is available in current phone
        if(HKHealthStore.isHealthDataAvailable()){
            healthStore = HKHealthStore()
        }
    }
}
