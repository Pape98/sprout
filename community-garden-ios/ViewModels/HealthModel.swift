//
//  HealthModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class HealthModel: ObservableObject {
    private let healthStore: HealthStore?
    
    init() {
        healthStore = HealthStore()
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    healthStore.startObserverQuery(dataType: HKDataTypes.stepCount)
                }
            }
        }
    }
}
