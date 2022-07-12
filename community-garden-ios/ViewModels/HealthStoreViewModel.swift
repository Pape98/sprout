//
//  HealthStoreViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 05/07/2022.
//

import Foundation

class HealthStoreViewModel: ObservableObject {
    
    let nc = NotificationCenter.default
    
    static let shared = HealthStoreViewModel()
    let healthStoreRepo = HealthStoreRepository.shared
    let healthStoreRepo2 = HealthStoreRepository2.shared
    let today = Date.now.getFormattedDate(format: "MM-dd-yyyy")
    var stepCounts: [Step] = []
    
    @Published var todayStepCount: Step?
    @Published var todayWalkingRunningDistance: WalkingRunningDistance?
    @Published var todayWorkout: Workout?
    @Published var todaySleep: Sleep?
    
    init(){
        setupObservers()
        getTodayData()
    }
    
    
    func getTodayData(){
        getTodayStepCount()
        getTodayWalkingRunningDistance()
        getTodayWorkout()
        getTodaySleep()
    }
    
    func setupObservers() {
        nc.addObserver(self,
                       selector: #selector(self.getTodayStepCount),
                       name: Notification.Name(NotificationType.FetchStepCount.rawValue),
                       object: nil)
        nc.addObserver(self,
                       selector: #selector(self.getTodayWalkingRunningDistance),
                       name: Notification.Name(NotificationType.FetchWalkingRunningDistance.rawValue),
                       object: nil)
        nc.addObserver(self,
                       selector: #selector(self.getTodayWorkout),
                       name: Notification.Name(NotificationType.FetchWorkout.rawValue),
                       object: nil)
        
        nc.addObserver(self,
                       selector: #selector(self.getTodaySleep),
                       name: Notification.Name(NotificationType.FetchSleep.rawValue),
                       object: nil)
        
    }
    
    @objc func getTodayStepCount() {
        DispatchQueue.main.async {
            self.healthStoreRepo2.getStepCountByDate(date: self.today) { result in
                self.todayStepCount = result
            }
        }
    }
    
    @objc func getTodayWalkingRunningDistance() {
        DispatchQueue.main.async {
            self.todayWalkingRunningDistance = self.healthStoreRepo.getWalkingRunningDistanceByDate(date: self.today)
        }
    }
    
    @objc func getTodayWorkout() {
        DispatchQueue.main.async {
            self.todayWorkout = self.healthStoreRepo.getWorkoutByDate(date: self.today)
        }
    }
    
    @objc func getTodaySleep() {
        DispatchQueue.main.async {
            self.todaySleep = self.healthStoreRepo.getSleepByDate(date: self.today)
        }
    }
}
