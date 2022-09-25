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
            
            let settings = UserService.user.settings!
            var tree = ""
            
            if settingKey == FirestoreKey.TREE {
                tree = "\(settings.treeColor)-\(addDash(value as! String))"
                self.updateTodaysTree(update: tree)
            } else if settingKey == FirestoreKey.TREE_COLOR {
                tree = "\(value as! String)-\(addDash(settings.tree))"
                self.updateTodaysTree(update: tree)
            }
        }
    }
    
    func updateTodaysTree(update: String){
        let collection = collections.getCollectionReference(CollectionName.gardenItems.rawValue)
                
        guard var tree = GardenViewModel.shared.tree else { return }
        tree.name = update
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
                UserService.user = user
                NotificationSender.send(type: NotificationType.UpdateUserService.rawValue)
            }
        }
    }
}
