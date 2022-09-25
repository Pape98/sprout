//
//  HistoryViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 23/08/2022.
//

import Foundation

class HistoryViewModel: ObservableObject {
    
    enum Data: String, CaseIterable {
        case sleep = "Sleep"
        case steps = "Steps"
        case workouts = "Workout Time"
        case walkingRunning = "Walking+running Distance"
        
        static var dalatList: [String] {
            return Data.allCases.map { $0.rawValue }
        }
    }
    
    static let shared  = HistoryViewModel()
    let healthstoreRepo: HealthStoreRepository = HealthStoreRepository.shared
    
    var steps: [Step] = []
    var sleep: [Sleep] = []
    var workouts: [Workout] = []
    var walkingRunning: [WalkingRunningDistance] = []
    
    
    var dataMapping: [String: [HealthData]] = [:]
    
    init(){
        if isUserTrackingData(DataOptions.steps) { getAllStepCounts() }
        if isUserTrackingData(DataOptions.sleep) { getAllSleep() }
        if isUserTrackingData(DataOptions.workouts) { getAllWorkouts() }
        if isUserTrackingData(DataOptions.walkingRunningDistance) { getAllWalkingRunning()}
    }
    
    func getAllStepCounts(){
        healthstoreRepo.getAllStepCount { steps in
            self.dataMapping["Steps"] = steps
        }
    }
    
    func getAllSleep(){
        healthstoreRepo.getAllSleep { sleep in
            self.dataMapping["Sleep"]  = sleep
        }
    }
    
    func getAllWorkouts(){
        healthstoreRepo.getAllWorkouts { workouts in
            self.dataMapping["Workout Time"]  = workouts
        }
    }
    
    func getAllWalkingRunning(){
        healthstoreRepo.getAllWalkingRunning { distances in
            self.dataMapping["Walking+running Distance"]  = distances
        }
    }
    
}
