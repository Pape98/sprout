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
    
    // To access and edit loggedInUser
    @Published var currentUser: User = UserService.shared.user
    
    static var shared = UserViewModel()
    
    let userRepository = UserRepository.shared
    let healthStore: HealthStoreService = HealthStoreService()
    
    let RATIO_STEPS_DROPLET = 200
    let MAX_NUM_STEPS = 10000
    let nc = NotificationCenter.default
    
    // MARK: - Methods
    
    init(){
        nc.addObserver(self, selector: #selector(self.initialSetup), name: Notification.Name(NotificationType.UserLoggedIn.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(self.getUser), name: Notification.Name(NotificationType.FetchUser.rawValue), object: nil)
    }
    
    @objc func initialSetup(){
        setupStepsListener()
        getUser()
        computeDroplets()
    }
    
    @objc func getUser() {
        let user = UserService.shared.user
        self.userRepository.fetchLoggedInUser(userID: user.id) { user in
            self.currentUser = user
            UserService.shared.user = user
        }
    }
    
    func computeDroplets(){
        
        let user = UserService.shared.user
        
        guard let stepCount = user.stepCount else { return }
        
        let currStepCount = stepCount.count
        let oldStepCount = user.oldStepCount
                
        // Making sure step count has a difference of at least 200 and total is less than 10,000
        let stepCountDifference = currStepCount - oldStepCount
        guard stepCountDifference >= RATIO_STEPS_DROPLET && currStepCount < MAX_NUM_STEPS else { return }
        let newNumberOfDroplets = Int(stepCountDifference / RATIO_STEPS_DROPLET) + user.numDroplets
        
        userRepository.updateUser(userID: user.id, updates: ["numDroplets": newNumberOfDroplets,
                                                             "oldStepCount": currStepCount - (stepCountDifference % 200) ]) {
            self.getUser()
        }
        
    }
        
    // Resets step count and tree data
    func resetUserData(){
        let updates: [String: Any] = ["oldStepCount": 0, "gardenItems": [["id": UUID().uuidString, "name": "tree1", "height": 0.03]]]
        userRepository.updateUser(userID: UserService.shared.user.id, updates: updates) {
            self.getUser()
        }
    }
    
    func setupStepsListener() {
        // Get user steps from Firestore first then listen to healthstore
        self.healthStore.setUpAuthorization(updateDailySteps: self.updateDailySteps)
    }
    
    func updateDailySteps(storeSteps: [Step]) {
        // Check if store step count is same as user saved step count
        let userStepCount = UserService.shared.user.stepCount
        guard storeSteps.isEmpty == false else { return }
     
        let storeStepCount = storeSteps[0]

        if userStepCount?.isSameDate(other: storeStepCount) == false {
            resetUserData()
        }
        
        if userStepCount != storeStepCount {
            let userID = UserService.shared.user.id
            // Perform the update operation

            self.userRepository.updateUser(userID: userID,
                                           updates: ["stepCount": ["count": storeStepCount.count, "date": storeStepCount.date]])
            { () in
                self.getUser()
                self.computeDroplets()
            }
        }
    }
}

