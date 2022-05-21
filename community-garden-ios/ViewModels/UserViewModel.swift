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
    
    // MARK: - Methods
    
    func getUser() {
        let user = UserService.shared.user
        self.userRepository.fetchLoggedInUser(userID: user.id) { user in
            self.currentUser = user
            UserService.shared.user = user
        }
    }
    
    func computeDroplets(){
        
//        let user = UserService.shared.user
//        
//        guard let steps = user.steps else { return }
//        
//        print(user)
//        
//        if let step = steps.first {
//            let count = step.count
//            
//            guard user.stepCount != nil else { return }
//            
//            // Making sure step count has a difference of at least 200 and total is less than 10,000
//            guard count - user.stepCount!.count >= RATIO_STEPS_DROPLET && count < MAX_NUM_STEPS else { return }
//            let newNumberOfDroplets = Int((count - user.stepCount!.count) / RATIO_STEPS_DROPLET) + user.numDroplets
//            
//            userRepository.updateUser(userID: user.id, updates: ["numDroplets": newNumberOfDroplets,
//                                                                 "oldStepCount": count - (count % 200) ]) {
//                
//                self.getUser()
//            }
//        }
    }
    
    func decreaseNumDroplets(){
        let newNumDroplets = currentUser.numDroplets - 1
        print(currentUser)
        userRepository.updateUser(userID: currentUser.id, updates: ["numDroplets": newNumDroplets]) {
            self.getUser()
        }
    }
    
    func setupSteps(completion: @escaping () -> Void) {
        // Get user steps from Firestore first then listen to healthstore
        self.healthStore.setUpAuthorization(updateDailySteps: self.updateDailySteps)
        completion()
    }
    
    func updateDailySteps(storeSteps: [Step]) {
        
        // Check if store step count is same as user saved step count
        let userStepCount = UserService.shared.user.stepCount
        let storeStepCount = storeSteps[0]
        
        if userStepCount != storeStepCount {
            let userID = UserService.shared.user.id
            // Perform the update operation
            self.userRepository.updateUser(userID: userID,updates: ["stepCount": ["count": storeStepCount.count, "date": storeStepCount.date]])
            { () in
                self.userRepository.fetchLoggedInUser(userID: userID) { user in
                    UserService.shared.user = user
                }
            }
        }
    }
}

