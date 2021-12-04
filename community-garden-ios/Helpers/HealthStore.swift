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
        print("here")
        // Check if health data is available in current phone
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    // @escaping means closure argument can outlive scope of caller
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        // List of health data that application needs to access
//        let healthKitTypesToRead = Set([HKQuantityType.quantityType(forIdentifier: .stepCount)])
        
        let allTypes = Set([HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .stepCount)!,
                            HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        // Unwrap healthStore and types variables
        guard let healthStoreUnwrapped = self.healthStore else {
            print("ERROR: problem has occured when unwrapping healthstore.")
            return completion(false)
        }
        
        // Asks authorization for given list of health data
        healthStoreUnwrapped.requestAuthorization(toShare: [], read: allTypes) { (success, error) in
            completion(success)
        }
    }
}
