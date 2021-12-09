//
//  HealthModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseAuth

class UserModel: ObservableObject {
    
    // MARK: - Properties
    
    // To access and edit loggedInUser
    @Published var currentUser: User = UserService.shared.user
    
    // To obtain data from health happ
    let healthStore: HealthStoreService = HealthStoreService()
    
    // To interact with firestore database
    let db: DatabaseService = DatabaseService.shared
    
    // User's daily step counts from store
    var storeSteps:[Step] = [Step]()
    
    @Published var steps:[Step] = [Step]()
    
    // MARK: - Methods
    
    init() {
        
        // Check if user meta data has been fetched. If the user was already logged in from a previous session, we need to get their data in a separate call
        if let userID = Auth.auth().currentUser?.uid {
            self.setUserData(userID: userID)
        }
        
        // Request authorization to access health store
        healthStore.requestAuthorization { success in
            if success {
                // Start listening to changes in step counts
                self.healthStore.startQuery(dataType: Constants.HKDataTypes.stepCount, updateHandler: self.updateDailySteps)
            }
        }
    }
    
    func setUserData(userID: String) {
        db.getUserData(userID: userID, collection: DatabaseService.Collection.steps) { result in
            DispatchQueue.main.async {
                print("Here1", self.currentUser.steps)
                self.currentUser.steps = result
                print("Here2", self.currentUser.steps)
            }
        }
    }
    
    func updateDailySteps(storeSteps: [Step]) {
        
        // Find the update
        let storeStepsSet = Set(storeSteps.map({$0}))
        let loggedInUserStepsSet = Set(currentUser.steps.map({$0}))
        let updatesSet = storeStepsSet.subtracting(loggedInUserStepsSet)
        
        guard let update = updatesSet.first,
              let userID = Auth.auth().currentUser?.uid
        else { return }
                
        // Perform the update operation
        db.updateUserTrackedData(userID: userID,
                                 collection: DatabaseService.Collection.steps,
                                 update: ["id": update.id, "count": update.count, "date": update.date])
        { () in
            // Get new list
            self.setUserData(userID: userID)
        }
        
  
    }
}
