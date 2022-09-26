//
//  CommunityViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/09/2022.
//

import Foundation

class CommunityViewModel: ObservableObject {
    static let shared = CommunityViewModel()
    
    let gardenRepository = GardenRepository.shared
    let userRepository = UserRepository.shared
    let groupRepository = GroupRepository.shared
    
    let collections = Collections.shared
    let nc = NotificationCenter.default
    
    @Published var members: [String: User] = [:]
    @Published var trees: [GardenItem] = []
    @Published var group: GardenGroup? = nil
    
    init(){
        fetchTrees()
        fetchGroupMembers()
        fetchGroup()
        
        nc.addObserver(self,
                       selector: #selector(self.fetchTrees),
                       name: Notification.Name(NotificationType.FetchCommunityTrees.rawValue),
                       object: nil)
    }
    
    func fetchGroup(){
        let groupNumber = UserService.user.group
        
        groupRepository.fetchGroup(groupNumber: groupNumber) { group in
            DispatchQueue.main.async {
                self.group = group
            }
        }
    }
    
    func fetchGroupMembers(){
        let userGroup = UserService.user.group
        let userID = getUserID()
        guard let userID = userID else { return }
        
        let collection = self.collections.getCollectionReference(CollectionName.users.rawValue)
        guard let collection = collection else { return }
        
        let query = collection.whereField("group", isEqualTo: userGroup)
            .whereField("id", isNotEqualTo: userID)
        
        userRepository.fetchAllUsers(query: query) { users in
            var temp: [String: User] = [:]
            
            for user in users {
                temp[user.id] = user
            }
            
            DispatchQueue.main.async {
                self.members = temp
            }
        }
    }
    
    @objc
    func fetchTrees(){
        let userGroup = UserService.user.group
        let collection = self.collections.getCollectionReference(CollectionName.gardenItems.rawValue)
        guard let collection = collection else { return }
        let query = collection.whereField("date", isEqualTo: Date.today)
            .whereField("group", isEqualTo: userGroup)
            .whereField("type", isEqualTo: GardenItemType.tree.rawValue)
        
        
        gardenRepository.getUserItems(query: query) { trees in
            DispatchQueue.main.async {
                self.trees = trees
            }
        }
    }
}
