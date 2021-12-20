//
//  HealthModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseAuth

class UserModel: ObservableObject {
    
    // Struct to publish changes to UI
    struct CurrentUserData {
        var steps: [Step] = [Step]()
    }
    
    // MARK: - Properties
    
    @Published var currentUserData = CurrentUserData()
    
    // To access and edit loggedInUser
    var currentUser: User = UserService.shared.user
    
    // To obtain data from health happ
    let healthStore: HealthStoreService = HealthStoreService()
    
    // To interact with firestore database
    let db: DatabaseService = DatabaseService.shared
    
    let authenticationModel: AuthenticationModel = AuthenticationModel()
    
    // User's daily step counts from store
    var storeSteps:[Step] = [Step]()
    
    // Steps data from Health Store
    var steps:[Step] = [Step]()
    
    // MARK: - Methods
    
    init() {
        
        // Check if user meta data has been fetched. If the user was already logged in from a previous session, we need to get their data in a separate call
        if let authUser = Auth.auth().currentUser {
            setUserData(userID: authUser.uid)
            currentUser.name = authUser.displayName!
            currentUser.email = authUser.email!
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
                self.currentUser.steps = result
                self.currentUserData.steps = result
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
                                 update: ["id": update.id!, "count": update.count, "date": update.date])
        { () in
            // Get new list
            self.setUserData(userID: userID)
        }
    }
    
    func addMoodEntry(moodType: String, date: Date) {
        print(moodType, date)
    }
}
