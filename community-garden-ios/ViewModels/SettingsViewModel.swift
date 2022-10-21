//
//  SettingsViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 7/19/22.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var settings = UserService.shared.user.settings
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
          
            if settingKey.rawValue.contains("Goal") == false {
                SproutAnalytics.shared.appCustomization(type: settingKey.rawValue)
            }
            
            guard var tree = GardenViewModel.shared.tree else { return }
            let settings = UserService.shared.user.settings!
            var name = ""
            
            if settingKey == FirestoreKey.TREE {
                name = "\(settings.treeColor)-\(addDash(value as! String))"
                tree.name = name
                self.updateTodaysTree(update: tree)
            } else if settingKey == FirestoreKey.TREE_COLOR {
                name = "\(value as! String)-\(addDash(settings.tree))"
                tree.name = name
                self.updateTodaysTree(update: tree)
            } else if settingKey == FirestoreKey.GARDEN_NAME {
                tree.gardenName = value as! String
                self.updateTodaysTree(update: tree)
            }
            
            GardenViewModel.shared.tree = tree
        }
    }
    
    func updateTodaysTree(update tree: GardenItem){
        gardenItemRepository.udpateGardenItem(docName: tree.documentName!, updates: tree){
            NotificationSender.send(type: NotificationType.GetUserItems.rawValue)
            NotificationSender.send(type: NotificationType.FetchCommunityTrees.rawValue)
        }
    }
    
    func fetchSettings(){
        let userID = getUserID()
        guard let userID = userID else { return }
        userRepository.fetchLoggedInUser(userID: userID) { user in
            DispatchQueue.main.async {
                self.settings = user.settings
                UserService.shared.user = user
                NotificationSender.send(type: NotificationType.UpdateUserService.rawValue)
            }
        }
    }
}
