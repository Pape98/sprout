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
        
        guard let healthStoreUnwrapped = self.healthStore else {
            return completion(false)
        }
        
        // Asks authorization for given list of health data
        healthStoreUnwrapped.requestAuthorization(toShare: [], read: healthKitTypesToRead) { (success, error) in
            guard error == nil else {
                assertionFailure("*** [HK] healthkit authorization request failed ***")
                return
            }
            completion(success)
        }
    }
    
    func startQuery(dataType: HKQuantityType) -> Void {

        let calendar = Calendar.current

        // Create a 1-day interval.
        let interval = DateComponents(day: 1)
        
        // Set the anchor for 12:00 a.m. on Monday.
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
            assertionFailure("*** [HK] unable to find the next Monday. ***")
            return
        }
        
        let query = HKStatisticsCollectionQuery(quantityType: dataType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            
            
            if let error = error as? HKError {
                    switch (error.code) {
                    case .errorDatabaseInaccessible:
                        assertionFailure("*** [HK] HealthKit couldn't access the database because the device is locked ***")
                        return
                    case .errorInvalidArgument:
                        assertionFailure("*** [HK] The app passed an invalid argument to the HealthKit API ***")
                        return
                    case .errorAuthorizationDenied:
                        assertionFailure("*** [HK] The user hasn’t given the app permission to save data. ***")
                        return
                    case .errorAuthorizationNotDetermined:
                        assertionFailure("*** [HK] The app hasn’t yet asked the user for the authorization required to complete the task. ***" )
                        return
                    case .errorNoData:
                        assertionFailure("*** [HK] Data is unavailable for the requested query and predicate. ***")
                        return
                    default:
                        assertionFailure("*** [HK] Unexpected error occured with Healthkit API ***" )
                        return
                    }
                }
            
            guard let statsCollection = results else {
                 assertionFailure("*** [HK] queried sample came back null ****")
                 return
             }
            
            let today = Date()
            
            let twoDaysAgo = DateComponents(day: -2)
            guard let startDate = calendar.date(byAdding: twoDaysAgo, to: today) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            statsCollection.enumerateStatistics(from: startDate, to: today) { statistics, stop in
                if let sum = statistics.sumQuantity() {
                    
                    let totalSteps = sum.doubleValue(for: .count())
                    print(statistics.startDate,totalSteps)
                }
            }
        }
        
        query.statisticsUpdateHandler = {
            query, results, collection, error in
            
            print("called")
            
        }
        
        if let healthStore = self.healthStore {
            healthStore.execute(query)
        }
        
    }
}
