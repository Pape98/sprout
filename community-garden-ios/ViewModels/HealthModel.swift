//
//  HealthModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class HealthModel: ObservableObject {
    
    // MARK: - Properties
    
    // Service to obtain data from health happ
    private let healthStore: HealthStoreService?
    
    // User's daily step counts
    @Published var dailySteps:[Step]
    
    // MARK: - Methods
    
    init() {
        healthStore = HealthStoreService()
        dailySteps = [Step]()
        
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    healthStore.startQuery(dataType: Constants.HKDataTypes.stepCount, updateHandler: self.updateDailySteps)
                }
            }
        }
    }

    func updateDailySteps(_ newDailySteps: [Step]) {
        dailySteps = newDailySteps
    }
}
