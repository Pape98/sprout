//
//  SettingsViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 7/19/22.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var settings = UserService.user.settings
    static let shared = SettingsViewModel()
    let appViewModel = AppViewModel.shared
    let userRepository = UserRepository()
    let gardenItemRepository = GardenRepository()
    let collections = Collections.shared
    let nc = NotificationCenter.default
    
    func updateSettings(settingKey: FirestoreKey, value: Any){
        let userID = getUserID()
        guard let userID = userID else { return }
        let key = "settings.\(settingKey.rawValue)"
                
        userRepository.updateUser(userID: userID, updates: [key: value]){
            SproutAnalytics.shared.appCustomization(type: settingKey.rawValue)
            
            if settingKey == FirestoreKey.TREE {
                self.updateTodaysTree(field: "settings.tree", update: value as! String)
            } else if settingKey == FirestoreKey.TREE_COLOR {
                self.updateTodaysTree(field: "settings.treeColor", update: value as! String)
            }
        }
    }
    
    func updateTodaysTree(field: String, update: String){
        let userID = getUserID()
        let collection = collections.getCollectionReference(CollectionName.gardenItems.rawValue)
        
        guard let collection = collection, let userID = userID else { return }
        let query = collection
            .whereField("date", isEqualTo: Date.today)
            .whereField("type", isEqualTo: "tree")
            .whereField("userID", isEqualTo: userID)
        
        gardenItemRepository.updateGardenItem(query: query, updates: [field : update])
        
    }
    
    func fetchSettings(){
        let userID = getUserID()
        guard let userID = userID else { return }
        userRepository.fetchLoggedInUser(userID: userID) { user in
            DispatchQueue.main.async {
                self.settings = user.settings
                UserService.user = user
                NotificationSender.send(type: NotificationType.UpdateUserService.rawValue)
            }
        }
    }
}
