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
    
    func startQuery(dataType: HKQuantityType) -> Void {

        let calendar = Calendar.current

        // Create a 1-day interval.
        let interval = DateComponents(day: 1)
        
        // Set the anchor for 0 a.m. on Monday.
        
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 0,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2) // Number 2 represents monday

        guard let anchorDate = calendar.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the next Monday. ***")
        }
        
        let query = HKStatisticsCollectionQuery(quantityType: dataType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            guard let statsCollection = results else {
                 assertionFailure("")
                 return
             }
            
            let twoDaysAgo = DateComponents(day: -2)
            
            guard let startDate = calendar.date(byAdding: twoDaysAgo, to: Date()) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            statsCollection.enumerateStatistics(from: startDate, to: Date()){ statistics, stop in
                print(statistics.sumQuantity())
            }
        }
        
        if let healthStore = self.healthStore {
            healthStore.execute(query)
        }
        
    }
}
