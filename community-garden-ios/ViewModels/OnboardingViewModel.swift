//
//  OnboardingViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 28/06/2022.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    
    static let shared = OnboardingViewModel()
    let userRepository = UserRepository.shared
    
    func saveSettings(values: [String: Any]){
        let userID = getUserID()
        if let userID = userID {
            userRepository.updateUser(userID: userID, updates: ["settings": values]) {
            }
        }
    }
    
    func updateOnboardedStatus(){
        let userID = getUserID()
        if let userID = userID {
            userRepository.updateUser(userID: userID, updates: ["hasBeenOnboarded": true]) {
            }
        }
    }

}
