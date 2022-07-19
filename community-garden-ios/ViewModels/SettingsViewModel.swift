//
//  SettingsViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 7/19/22.
//

import Foundation

class SettingsViewModel: ObservableObject {
    static let shared = SettingsViewModel()
    let userRepository = UserRepository()
    
    func updateSettings(settingKey: FirestoreKey, value: Any){
        let userID = getUserID()
        guard let userID = userID else { return }
        let key = "settings.\(settingKey.rawValue)"
        userRepository.updateUser(userID: userID, updates: [key: value]){
            NotificationSender.send(type: NotificationType.FetchUser.rawValue)
        }
    }
}
