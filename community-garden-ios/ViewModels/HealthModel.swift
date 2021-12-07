//
//  HealthModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class HealthModel: ObservableObject {
    
    // MARK: - Properties

    private let healthStore: HealthStore?
    @Published var dailySteps:[Step]
    
    // MARK: - Methods
    
    init() {
        healthStore = HealthStore()
        dailySteps = [Step]()
        
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    healthStore.startQuery(dataType: Constants.HKDataTypes.stepCount, updateHandler: self.updateDailySteps)
                }
            }
        }
    }

    func updateDailySteps(_ newDailySteps: [Step]) -> Void {
        dailySteps = newDailySteps
    }
}
