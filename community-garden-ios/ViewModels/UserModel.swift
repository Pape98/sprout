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
    
    // Service to access and edit loggedInUser
    private let loggedInUser: User = UserService.shared.loggedInUser
    
    // User's daily step counts
    @Published var dailySteps:[Step] = [Step]()
    
    // MARK: - Methods
    
    init() {
        // Request authorization to access health store
        healthStore.requestAuthorization { success in
            if success {
                // Start listening to changes in step counts
                self.healthStore.startQuery(dataType: Constants.HKDataTypes.stepCount, updateHandler: self.updateDailySteps)
            }
        }
    }
    
    func updateDailySteps(_ newDailySteps: [Step]) {
        dailySteps = newDailySteps
    }
}
