//
//  HealthModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseAuth
import UserNotifications

class UserViewModel: ObservableObject {
    
    // Struct to publish changes to UI
    struct CurrentUserData {
        var steps: [Step] = [Step]()
        var moods: [Mood] = [Mood]()
    }
    
    // MARK: - Properties
    
    @Published var currentUserData = CurrentUserData()
    
    // To access and edit loggedInUser
    var currentUser: User = UserService.shared.user
    
    // To obtain data from health happ
    let healthStore: HealthStoreService = HealthStoreService()
    
    // To interact with firestore database
    let db: DatabaseService = DatabaseService.shared
    
    // User's daily step counts from store
    var storeSteps:[Step] = [Step]()
    
    // Steps data from Health Store
    var steps:[Step] = [Step]()
    
    // MARK: - Methods
    
    init() {
        
        // Check if user meta data has been fetched. If the user was already logged in from a previous session, we need to get their data in a separate call
        if let authUser = Auth.auth().currentUser {
            currentUser.name = authUser.displayName!
            currentUser.email = authUser.email!
            currentUser.id = authUser.uid
            setCurrentUserData()
        }
    }
    
    func setCurrentUserData() {
        getCurrentUserSteps()
        getCurrentUserMoodEntries()
    }
    
    func getCurrentUserSteps() {
        db.getUserSteps(userID: currentUser.id, collection: DatabaseService.Collection.steps) { result in
            DispatchQueue.main.async {
                self.currentUser.steps = result
                self.currentUserData.steps = result
            }
        }
    }
    
    func getCurrentUserMoodEntries() {
        db.getMoodEntries(userId: currentUser.id) { result in
            DispatchQueue.main.async {
                self.currentUser.moods = result
                self.currentUserData.moods = result
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
                                 update: ["count": update.count, "date": update.date])
        { () in
            // Get new list
            self.getCurrentUserSteps()
        }
    }
    
    func addMoodEntry(moodType: String, date: Date) {
        db.addMoodEntry(text: moodType,
                        date: date,
                        userId: currentUser.id) { () in
            
            self.getCurrentUserMoodEntries()
        }
    }
}
