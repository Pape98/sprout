//
//  HealthModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class UserModel: ObservableObject {
    
    // MARK: - Properties
    
    // Service to obtain data from health happ
    private let healthStore: HealthStoreService = HealthStoreService()
    
    // Service to interact with firestore database
    private let databaseService: DatabaseService = DatabaseService.shared
    
    // Service to access and edit loggedInUser
    private let loggedInUser: User = UserService.shared.user
    
    
    
    // User's daily step counts
    @Published var dailySteps:[Step] = [Step]()
    
    // MARK: - Methods
    
    init() {
        // Request authorization to access health store
//        healthStore.requestAuthorization { success in
//            if success {
//                // Start listening to changes in step counts
//                self.healthStore.startQuery(dataType: Constants.HKDataTypes.stepCount, updateHandler: self.updateDailySteps)
//            }
//        }
    }
    
    func updateDailySteps(storeSteps: [Step]) {
        self.dailySteps = storeSteps
        
        // Find the update
        let storeStepsSet = Set(dailySteps.map({$0}))
        let loggedInUserStepsSet = Set(loggedInUser.steps.map({$0}))
        let updatesSet = storeStepsSet.subtracting(loggedInUserStepsSet)
        let update = updatesSet.first!
        
        var l = UserService.shared.user
        
        // Perform the update operation
//        databaseService.updateUserTrackedData(userID: loggedInUser.id,
//                                              collection: DatabaseService.Collection.steps,
//                                              update: ["id": update.id, "steps": update.count, "date": update.date])
    }
}
