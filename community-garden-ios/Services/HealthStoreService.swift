//
//  HealthStore.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import Foundation
import HealthKit

class HealthStoreService {
    
    struct HKDataTypes {
        static let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)!
        static let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        static let walkingRunningDistance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        static let exerciseTime = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        static let workouts = HKObjectType.workoutType()
    }
    
    // MARK: - Properties
    
    // Provides all functionalities related health data
    private var healthStore: HKHealthStore?
    private let dataCollectionStartDate = Date() // (day, month, year)
    private let SQLite = SQLiteService.shared
    private let units = [
        HKDataTypes.stepCount: HKUnit.count(),
        HKDataTypes.walkingRunningDistance: HKUnit.mile(),
        HKDataTypes.sleep: HKUnit.hour(),
        HKDataTypes.workouts: HKUnit.minute()
    ]
    
    // MARK: - Methods
    init() {
        // Check if health data is available in current phone
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func setUpAuthorization() {
        // Request authorization to access health store if not asked yet
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" { // Do not run this in preview mode
            self.requestAuthorization { success in
                if success {
                    // Listen to changes in step counts
                    self.startQuantityQuery(dataType: HKDataTypes.stepCount,
                                            updateHandler: self.SQLite.saveStepCount)

                    // Listen to changes in walking+running distance
                    self.startQuantityQuery(dataType: HKDataTypes.walkingRunningDistance,
                                            updateHandler: self.SQLite.saveWalkingRunningDistance)
                    
                    // Listen to changes in workouts
                    self.startSampleQuery(sampleType: HKDataTypes.workouts,
                                          dataType: HKWorkout.self,
                                          updateHandler: self.SQLite.saveWorkouts)
                    
                    // Listen to changes in sleep
                    self.startSampleQuery(sampleType: HKDataTypes.sleep,
                                          dataType: HKCategorySample.self,
                                          updateHandler: self.SQLite.saveSleep)
                }
            }
        }
    }
    
    // @escaping means closure argument can outlive scope of caller
    func requestAuthorization(completion: @escaping (Bool)  -> Void) {
        
        let healthKitTypesToRead = Set([
            HKDataTypes.walkingRunningDistance,
            HKDataTypes.exerciseTime,
            HKDataTypes.sleep,
            HKDataTypes.stepCount,
            HKDataTypes.workouts
        ])
        
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
    
    func startSampleQuery<T: HKSample>(sampleType: HKSampleType, dataType: T.Type, updateHandler: @escaping (Double) -> Void){
        
        // Query descriptor
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        // Query predicate
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date.now)
        let date = Calendar.current.date(from: components)
        let predicate = NSPredicate(format: "startDate > %@", date! as NSDate)
        
        // Observer query
        let observerQuery = HKObserverQuery(sampleType: sampleType, predicate: predicate) { query, completionHandler, error in

            if let error = error {
                // Properly handle the error.
                print(error)
                return
            }

            let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                            predicate: predicate,
                                            limit: 500,
                                            sortDescriptors: [sortDescriptor]) { query, result, error in
                // Handle error
                if let error = error {
                    print(error)
                    return
                }
                guard result != nil else { return }

                var duration = 0.0
                
                for item in result! {
                    let sample = item  as? T
                    guard sample != nil else { return }
                    duration += (sample!.endDate - sample!.startDate)/60
                }
                
                updateHandler(duration)
            }

            // Execute sample query
            if let healthStore = self.healthStore {
                healthStore.execute(sampleQuery)
            }

        }

        // Execute observer query
        if let healthStore = self.healthStore {
            healthStore.execute(observerQuery)
        }
        
    }
        
    func startQuantityQuery(dataType: HKQuantityType, updateHandler: @escaping (Double) -> Void) -> Void {
        
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
            self.statsInitialUpdateHandler(query: query,
                                           statistics: statistics,
                                           error: error,
                                           unit: self.units[dataType]!,
                                           updateHandler: updateHandler)
        }
        
        // The results handler for monitoring updates to the HealthKit store.
        query.statisticsUpdateHandler = {
            query, statistics, collection, error in
            self.statsInitialUpdateHandler(query: query,
                                           statistics: collection,
                                           error: error,
                                           unit: self.units[dataType]!,
                                           updateHandler: updateHandler)
        }
        
        // Execute query
        if let healthStore = self.healthStore {
            healthStore.execute(query)
        }
        
    }
    
    // Handles both initial and subsequendes data fetches from health store
    func statsInitialUpdateHandler(query:HKStatisticsCollectionQuery,
                                   statistics: HKStatisticsCollection?,
                                   error:Error?,
                                   unit: HKUnit,
                                   updateHandler: @escaping (Double) -> Void) -> Void {
        
        let calendar = Calendar.current
        
        if let error = error as? HKError {
            print(error)
            return
        }
        
        guard let statsCollection = statistics else {
            assertionFailure("*** [HK] queried sample came back null ****")
            return
        }
        
        let today = Date()
        
        guard let startDate = (DateComponents(calendar:calendar,
                                              timeZone: calendar.timeZone,
                                              year: Int(today.year),
                                              month:Int(today.month),
                                              day: Int(today.day))).date else { return }
        
        statsCollection.enumerateStatistics(from: startDate, to: today) { statistics, stop in
            if let sum = statistics.sumQuantity() {
                let total = sum.doubleValue(for: unit)
                updateHandler(total)
            }
        }
        
        // Dispatch to the main queue to update the UI.
//        DispatchQueue.main.async {
//            updateHandler(2.5)
//        }
    }
    
}
