//
//  HealthStore.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import Foundation
import HealthKit


class HealthStoreService {
    
    // MARK: - Properties

    // Provides all functionalities related health data
    private var healthStore: HKHealthStore?
    
    // MARK: - Methods

    init() {
        // Check if health data is available in current phone
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    // @escaping means closure argument can outlive scope of caller
    func requestAuthorization(completion: @escaping (Bool)  -> Void) {
        
        let healthKitTypesToRead = Set([Constants.HKDataTypes.stepCount])
        
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
    
    // Handles both initial and subsequendes data fetches from health store
    func statsInitialUpdateHandler(query:HKStatisticsCollectionQuery,
                                   statistics: HKStatisticsCollection?,
                                   error:Error?,
                                   updateHandler: @escaping (_ newValues:[Step]) -> Void) -> Void {
        
        let calendar = Calendar.current
        
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
        
        guard let statsCollection = statistics else {
             assertionFailure("*** [HK] queried sample came back null ****")
             return
         }
        
        let today = Date()
        
        guard let startDate = (DateComponents(calendar:calendar,
                                              timeZone: calendar.timeZone,
                                              year: 2021,
                                              month:12)).date else { return }
        
        // TODO: Generalize to accept other statistics and not just steps
        var dailySteps: [Step] = []
        
        statsCollection.enumerateStatistics(from: startDate, to: today) { statistics, stop in
            if let sum = statistics.sumQuantity() {
                let totalSteps = Int(sum.doubleValue(for: .count()))
                let date = statistics.startDate.getFormattedDate(format: "MM-dd-YYYY")
                let stepObject = Step(date: date, count: totalSteps)
                dailySteps.append(stepObject)
            }
        }
                        
        // Dispatch to the main queue to update the UI.
        DispatchQueue.main.async {
            updateHandler(dailySteps)
        }
    }
    
    func startQuery(dataType: HKQuantityType, updateHandler: @escaping (_ newValues:[Step]) -> Void) -> Void {
        
        let calendar = Calendar.current
        // Create a 1-day interval.
        let interval = DateComponents(day: 1)
        // Set the anchor for 12:00 a.m. on Monday.
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 0,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2) // 1 = Sunday, 2 = Monday
        
        // Starting date for data gathering
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
        
        // The results handler for the query’s initial results.
        query.initialResultsHandler = {
            query, statistics, error in
            self.statsInitialUpdateHandler(query: query, statistics: statistics, error: error, updateHandler: updateHandler)
        }
        
        // The results handler for monitoring updates to the HealthKit store.
        query.statisticsUpdateHandler = {
            query, statistics, collection, error in
            self.statsInitialUpdateHandler(query: query, statistics: collection, error: error, updateHandler: updateHandler)
        }
        
        // Execute query
        if let healthStore = self.healthStore {
            healthStore.execute(query)
        }
        
    }
        
}
