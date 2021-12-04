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
    private var healthStore: HKHealthStore?
    
    init() {
        // Check if health data is available in current phone
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    // @escaping means closure argument can outlive scope of caller
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        let healthKitTypesToRead = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        // Unwrap healthStore
        guard let healthStoreUnwrapped = self.healthStore else {
            print("[ERROR: HealthKit] Problem occured when unwrapping healthStore.")
            return completion(false)
        }
        
        // Asks authorization for given list of health data
        healthStoreUnwrapped.requestAuthorization(toShare: [], read: healthKitTypesToRead) { (success, error) in
            completion(success)
        }
    }
}
