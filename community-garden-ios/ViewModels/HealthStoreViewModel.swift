//
//  HealthStoreViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/4/22.
//

import Foundation
import FirebaseAuth

class HealthStoreViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var steps: [Step] = [Step]()
    @Published var num: Int = 0
    
    var currentUser: User = UserService.shared.user
    
    func add(){
        print(self.steps)
    }
    
    static var shared = HealthStoreViewModel()
    
    // To access and edit loggedInUser
    
    // To obtain data from health happ
    let healthStore: HealthStoreService = HealthStoreService()
    
    
    // To interact with firestore database
    let healthStoreRepository: HealthStoreRepository = HealthStoreRepository.shared
    
    // MARK: - Methods
    
    func setupSteps() {
        // Get user steps from Firestore first then listen to healthstore
        self.getCurrentUserSteps() {
            self.healthStore.setUpAuthorization(updateDailySteps: self.updateDailySteps)
        }
        
    }
    
    func getCurrentUserSteps(completion: @escaping () -> Void) {
        healthStoreRepository.getData(userID: UserService.shared.user.id, collectionName: "steps", objectType: Step.self) { result in
            DispatchQueue.main.async {
                self.steps = result
                print(result)
                completion()
            }
        }
    }
    
    func updateDailySteps(storeSteps: [Step]) {
        
        // Find the update
        let storeStepsSet = Set(storeSteps.map({$0}))
        let loggedInUserStepsSet = Set(self.steps.map({$0}))
        let updatesSet = storeStepsSet.subtracting(loggedInUserStepsSet)
        
        guard let update = updatesSet.first
        else { return }
        
        // Perform the update operation
        healthStoreRepository.updateUserTrackedData(userID: UserService.shared.user.id,
                                                    collectionName: "steps",
                                                    update: ["count": update.count, "date": update.date])
        { () in
            // Get new list
            self.getCurrentUserSteps(){}
        }
    }
}
