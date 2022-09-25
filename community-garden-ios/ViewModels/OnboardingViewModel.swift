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
                NotificationSender.send(type: NotificationType.FetchUser.rawValue)
                NotificationSender.send(type: NotificationType.GetUserItems.rawValue)
            }
        }
    }
    
    func updateTokenAndStatus(){
        var updates: [String: Any] = ["hasBeenOnboarded": true]
        let token: String? = UserDefaultsService.shared.get(key: UserDefaultsKey.FCM_TOKEN)
        if token != nil {
            updates["fcmToken"] = token!
        }
        
        updateUser(updates: updates) {}
    }
    
    func updateUser(updates: [String: Any], completion: @escaping () -> Void){
        let userID = getUserID()
        if let userID = userID {
            userRepository.updateUser(userID: UserService.user.id, updates: updates) {
                completion()
            }
        }
    }
    
}
