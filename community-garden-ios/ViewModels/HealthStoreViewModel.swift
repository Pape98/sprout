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
    let goalsRepo = GoalsRepository.shared
    let progressRepo = ProgressRepository.shared
    let collections = Collections.shared
        
    let today = Date.today
    var stepCounts: [Step] = []
    
    @Published var todayStepCount: Step?
    @Published var todayWalkingRunningDistance: WalkingRunningDistance?
    @Published var todayWorkout: Workout?
    @Published var todaySleep: Sleep?
    @Published var showGoalCompletedAlert = false
    
    var goalCompletedAlertSubtitle = ""
    var goalCompletedAlertImage = ""
    
    init(){
        setupObservers()
        getTodayData()
    }
    
    
    func getTodayData(){
        if isUserTrackingData(DataOptions.steps) { getTodayStepCount() }
        if isUserTrackingData(DataOptions.sleep) { getTodaySleep() }
        if isUserTrackingData(DataOptions.workouts) { getTodayWorkout() }
        if isUserTrackingData(DataOptions.walkingRunningDistance) { getTodayWalkingRunningDistance()}
    }
    
    func setGoalCompletionAlertData(subtitle: String = "", image: String){
        goalCompletedAlertSubtitle = subtitle
        goalCompletedAlertImage = image
        AudioPlayer.shared.playCustomSound(filename: "congratulations")
        showGoalCompletedAlert = true
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
    
    func hasUserMetSleepGoal(data: DataOptions) -> Bool {
        guard let settings = UserService.shared.user.settings else { return false }
        let goal = settings.sleepGoal
        let progress = progressRepo.getSleepProgress()
        return progress.old >= Double(goal!)
        
    }
    
    func hasUserMetStepGoal(data: DataOptions) -> Bool {
        guard let settings = UserService.shared.user.settings else { return false }
        let goal = settings.stepsGoal
        let progress = progressRepo.getStepProgress()
        return progress.old >= Double(goal!)
        
    }
    
    func hasUserMetWorkoutsGoal(data: DataOptions) -> Bool {
        guard let settings = UserService.shared.user.settings else { return false }
        let goal = settings.workoutsGoal
        let progress = progressRepo.getWorkoutsProgress()
        return progress.old >= Double(goal!)
        
    }
    
    func hasUserMetWalkingRunningGoal(data: DataOptions) -> Bool {
        guard let settings = UserService.shared.user.settings else { return false }
        let goal = settings.walkingRunningGoal
        let progress = progressRepo.getWalkingRunningProgress()
        return progress.old >= Double(goal!)
        
    }
    
    @objc func getTodayStepCount() {
        DispatchQueue.main.async {
            self.healthStoreRepo.getStepCountByDate(date: self.today) { result in
                self.todayStepCount = result
                guard let goal = result.goal else { return }
                                
                if result.count >= Double(goal) && result.hasReachedGoal == nil {
                    self.goalsRepo.updateGoalsAchieved(data: DataOptions.steps){
                        NotificationSender.send(type: NotificationType.FetchGoalStat.rawValue)
                    }
                    self.updateTrackedData(data: HealthStoreRepository.Data.steps, updates: ["hasReachedGoal": true])
                    self.setGoalCompletionAlertData(image: "figure.walk")
                }
            }
        }
    }
    
    @objc func getTodayWalkingRunningDistance() {
        DispatchQueue.main.async {
            self.healthStoreRepo.getWalkingRunningDistanceByDate(date: self.today) { result in
                self.todayWalkingRunningDistance = result
                guard let goal = result.goal else { return }

                if result.distance >= Double(goal) && result.hasReachedGoal == nil {
                    self.goalsRepo.updateGoalsAchieved(data: DataOptions.walkingRunningDistance){
                        NotificationSender.send(type: NotificationType.FetchGoalStat.rawValue)
                    }
                    self.updateTrackedData(data: HealthStoreRepository.Data.walkingRunning, updates: ["hasReachedGoal": true])
                    self.setGoalCompletionAlertData(image: "sportscourt.fill")
                }
            }
        }
    }
    
    @objc func getTodayWorkout() {
        DispatchQueue.main.async {
            self.healthStoreRepo.getWorkoutByDate(date: self.today) { result in
                self.todayWorkout = result
                guard let goal = result.goal else { return }

                if result.duration >= Double(goal) && result.hasReachedGoal == nil {
                    self.goalsRepo.updateGoalsAchieved(data: DataOptions.workouts){
                        NotificationSender.send(type: NotificationType.FetchGoalStat.rawValue)
                    }
                    self.updateTrackedData(data: HealthStoreRepository.Data.workouts, updates: ["hasReachedGoal": true])
                    self.setGoalCompletionAlertData(image: "dumbbell")
                }
            }
        }
    }
    
    @objc func getTodaySleep() {
        DispatchQueue.main.async {
            self.healthStoreRepo.getSleepByDate(date: self.today) { result in
                self.todaySleep = result
                guard let goal = result.goal  else { return }
                
                if result.duration >= Double(goal) && result.hasReachedGoal == nil {
                    self.goalsRepo.updateGoalsAchieved(data: DataOptions.sleep){
                        NotificationSender.send(type: NotificationType.FetchGoalStat.rawValue)
                    }
                    self.updateTrackedData(data: HealthStoreRepository.Data.sleep, updates: ["hasReachedGoal": true])
                    self.setGoalCompletionAlertData(image: "bed.double")
                }
            }
        }
    }
    
    func updateTrackedData(data: HealthStoreRepository.Data, updates: [String: Any]){
        let collection = collections.getCollectionReference(data.rawValue)
        guard let collection = collection else { return }
        let user = UserService.shared.user
        let docRef = collection.document("\(user.id)-\(Date.today)")
        
        healthStoreRepo.saveData(docRef: docRef, updates: updates){
            NotificationSender.send(type: NotificationType.FetchGoalStat.rawValue)
        }
    }
}
