//
//  HistoryViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 23/08/2022.
//

import Foundation

class HistoryViewModel: ObservableObject {
    
    enum Data: String, CaseIterable {
        case sleep, steps, workouts, walkingRunning
        
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
        getAllStepCounts()
        getAllSleep()
        getAllWorkouts()
        getAllWalkingRunning()
    }
    
    func getAllStepCounts(){
        healthstoreRepo.getAllStepCount { steps in
            self.dataMapping["steps"] = steps
        }
    }
    
    func getAllSleep(){
        healthstoreRepo.getAllSleep { sleep in
            self.dataMapping["sleep"]  = sleep
        }
    }
    
    func getAllWorkouts(){
        healthstoreRepo.getAllWorkouts { workouts in
            self.dataMapping["workouts"]  = workouts
        }
    }
    
    func getAllWalkingRunning(){
        healthstoreRepo.getAllWalkingRunning { distances in
            self.dataMapping["walkingRunning"]  = distances
        }
    }
    
}
