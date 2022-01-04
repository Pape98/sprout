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
    
    // To access and edit loggedInUser
    var currentUser: User = UserService.shared.user
    
    // To obtain data from health happ
    let healthStore: HealthStoreService = HealthStoreService()
    
    // To interact with firestore database
    let healthStoreRepository: HealthStoreRepository = HealthStoreRepository.shared
    
    // MARK: - Methods
    
    init() {
        healthStore.setUpAuthorization(updateDailySteps: updateDailySteps)
        self.getCurrentUserSteps()
    }
    
    func getCurrentUserSteps() {
        healthStoreRepository.getData(userID: currentUser.id, collectionName: "steps", objectType: Step.self) { result in
            DispatchQueue.main.async {
                self.steps = result
            }
        }
    }
    
    func updateDailySteps(storeSteps: [Step]) {
        
        // Find the update
        let storeStepsSet = Set(storeSteps.map({$0}))
        let loggedInUserStepsSet = Set(self.steps.map({$0}))
        let updatesSet = storeStepsSet.subtracting(loggedInUserStepsSet)

        guard let update = updatesSet.first,
              let userID = Auth.auth().currentUser?.uid
        else { return }
        
        // Perform the update operation
        healthStoreRepository.updateUserTrackedData(userID: userID,
                                 collectionName: "steps",
                                 update: ["count": update.count, "date": update.date])
        { () in
            // Get new list
            self.getCurrentUserSteps()
        }
    }
}
