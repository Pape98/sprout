//
//  HealthModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseAuth

class UserViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var currentUser: User = UserService.shared.user
    @Published var numDroplets: Stat?
    @Published var numSeeds: Stat?
    
    static var shared = UserViewModel()
    
    let userRepository = UserRepository.shared
    let statsRepository = StatsRepository.shared
    let progressRepository = ProgressRepository.shared
    
    let nc = NotificationCenter.default
    
    // MARK: - Methods
    
    init(){
        setupObservers()
        getNumDroplets()
        getNumSeeds()
        
        nc.addObserver(self,
                       selector: #selector(self.getUser),
                       name: Notification.Name(NotificationType.UpdateUserService.rawValue),
                       object: nil)
    }
    
    @objc func initialSetup(){
        getUser()
    }
    
    @objc func getUser() {
        let userID = getUserID()
        guard let userID = userID else {
            return
        }
        
        self.userRepository.fetchLoggedInUser(userID: userID) { user in
            DispatchQueue.main.async {
                self.currentUser = user
                self.handleResets()
            }
        }
    }
    
    @objc func getUserNewUpdates(){
        DispatchQueue.main.async {
            self.currentUser = UserService.shared.user
        }
    }
    
    @objc func updateNumDroplets(_ notification: Notification){
        let notiticationType = NotificationType(rawValue: notification.name.rawValue)
        let userInfo = notification.userInfo as? [String: Double] ?? [:]
        let value = userInfo["message"]!
        
        switch notiticationType {
        case .FetchStepCount:
            statsRepository.stepsChangeCallback(value: value)
        case .FetchWalkingRunningDistance:
            statsRepository.walkingRunningChangeCallback(value: value)
        case .FetchWorkout:
            statsRepository.workoutsChangeCallback(value: value)
        case .FetchSleep:
            statsRepository.sleepChangeCallback(value: value)
        default:
            print("Error in updateNumDroplets")
        }
        
        getNumDroplets()
        getNumSeeds()
    }
    
    func getNumDroplets(){
        DispatchQueue.main.async {
            self.numDroplets = self.statsRepository.getNumDroplets()
        }
    }
    
    func getNumSeeds(){
        DispatchQueue.main.async {
            self.numSeeds = self.statsRepository.getNumSeeds()
        }
    }
    
    func updateUser(updates: [String: Any], completion: @escaping () -> Void){
        userRepository.updateUser(userID: UserService.shared.user.id, updates: updates) {
            completion()
        }
    }
    
    func handleResets(){
        let lastResetDate = UserService.shared.user.lastReset
        
        if lastResetDate != Date.today {
            SQLiteService.shared.resetTableValues(forceReset: true)
            updateUser(updates: ["lastReset" : Date.today]) {
                UserService.shared.user.lastReset = Date.today
            }
        }
    }
    
    func setupObservers(){
        nc.addObserver(self,
                       selector: #selector(self.initialSetup),
                       name: Notification.Name(NotificationType.UserLoggedIn.rawValue),
                       object: nil)
        
        nc.addObserver(self,
                       selector: #selector(self.getUser),
                       name: Notification.Name(NotificationType.FetchUser.rawValue),
                       object: nil)
        
        nc.addObserver(self,
                       selector: #selector(self.getUserNewUpdates),
                       name: Notification.Name(NotificationType.UpdateUserService.rawValue),
                       object: nil)
        
        nc.addObserver(self,
                       selector: #selector(self.updateNumDroplets(_:)),
                       name: Notification.Name(NotificationType.FetchStepCount.rawValue),
                       object: nil)
        
        nc.addObserver(self,
                       selector: #selector(self.updateNumDroplets),
                       name: Notification.Name(NotificationType.FetchWalkingRunningDistance.rawValue),
                       object: nil)
        nc.addObserver(self,
                       selector: #selector(self.updateNumDroplets),
                       name: Notification.Name(NotificationType.FetchWorkout.rawValue),
                       object: nil)
        
        nc.addObserver(self,
                       selector: #selector(self.updateNumDroplets),
                       name: Notification.Name(NotificationType.FetchSleep.rawValue),
                       object: nil)
    }
}

