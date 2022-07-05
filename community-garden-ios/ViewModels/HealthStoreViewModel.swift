//
//  HealthStoreViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 05/07/2022.
//

import Foundation

class HealthStoreViewModel: ObservableObject {
    
    static let shared = HealthStoreViewModel()
    let healthStoreRepo = HealthStoreRepository.shared
    
    init(){
        healthStoreRepo.getTodayStepCount()
    }

}
