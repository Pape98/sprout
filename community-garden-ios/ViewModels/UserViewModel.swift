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
    
    static var shared = UserViewModel()
    
    let userRepository = UserRepository.shared
    let statsRepository = StatsRepository.shared
    
    let nc = NotificationCenter.default
    var updateNumDropletsCallback: [NotificationType: () -> Void] { [
        .FetchStepCount: statsRepository.updateStepsNumDroplets,
        .FetchWalkingRunningDistance: statsRepository.updateWalkingRunningNumDroplets,
        .FetchWorkout: statsRepository.updateWorkoutsNumDroplets,
        .FetchSleep: statsRepository.updateSleepNumDroplets
    ]}
    
    // MARK: - Methods
    
    init(){
//        setupObservers()
        getNumDroplets()
    }
    
    @objc func initialSetup(){
        getUser()
    }
    
    @objc func getUser() {
        let user = UserService.shared.user
        self.userRepository.fetchLoggedInUser(userID: user.id) { user in
            self.currentUser = user
            UserService.shared.user = user
        }
    }
    
    @objc func updateNumDroplets(_ notification: Notification){
        let notiticationType = NotificationType(rawValue: notification.name.rawValue)
        if let type = notiticationType {
            let updateCallback = updateNumDropletsCallback[type]
            updateCallback!()
        }
    }
    
    func getNumDroplets(){
        DispatchQueue.main.async {
            self.numDroplets = self.statsRepository.getNumDroplets()
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

