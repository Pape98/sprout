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
    func requestAuthorization(completion: @escaping (Bool)  -> Void) {
        
        let healthKitTypesToRead = Set([HKDataTypes.stepCount, HKDataTypes.distanceWalkingRunning])
        
        // Unwrap healthStore
        guard let healthStoreUnwrapped = self.healthStore else {
            return completion(false)
        }
        
        // Asks authorization for given list of health data
        healthStoreUnwrapped.requestAuthorization(toShare: [], read: healthKitTypesToRead) { (success, error) in
            guard error == nil else {
                return
            }
            completion(success)
        }
    }
    
    func startObserverQuery(dataType: HKSampleType) -> Void {
        
        healthStore?.enableBackgroundDelivery(for: dataType, frequency: HKUpdateFrequency.immediate) { success, error in
            guard error == nil else {
                print(error!)
                return
            }
        }
        
        let observerQuery = HKObserverQuery.init(sampleType: dataType, predicate: nil) { (query, completionHandler, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            let sampleQuery = HKSampleQuery(sampleType: dataType, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil){
                query, results, error in
            
                guard let samples = results as? [HKQuantitySample] else {
                    return
                }
                
                print(samples.count)
                
            }
            
            self.healthStore?.execute(sampleQuery)
            
            completionHandler()
        }
        
        healthStore?.execute(observerQuery)
        
    }
}
