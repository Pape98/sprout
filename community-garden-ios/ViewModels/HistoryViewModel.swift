//
//  HistoryViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 23/08/2022.
//

import Foundation

class HistoryViewModel: ObservableObject {
    static let shared  = HistoryViewModel()
    let healthstoreRepo: HealthStoreRepository = HealthStoreRepository.shared
    
    @Published var steps: [Step] = []
    @Published var sleep: [Sleep] = []
    @Published var workouts: [Workout] = []
    @Published var walkingRunning: [WalkingRunningDistance] = []
    
    init(){
        getAllStepCounts()
        getAllSleep()
        getAllWorkouts()
        getAllWalkingRunning()
    }
    
    func getAllStepCounts(){
        healthstoreRepo.getAllStepCount { steps in
            self.steps = steps
        }
    }
    
    func getAllSleep(){
        healthstoreRepo.getAllSleep { sleep in
            self.sleep = sleep
        }
    }
    
    func getAllWorkouts(){
        healthstoreRepo.getAllWorkouts { workouts in
            self.workouts = workouts
        }
    }
    
    func getAllWalkingRunning(){
        healthstoreRepo.getAllWalkingRunning { distances in
            self.walkingRunning = distances
        }
    }
    
}
