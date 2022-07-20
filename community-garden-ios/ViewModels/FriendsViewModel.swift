//
//  FriendsViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import Foundation

class FriendsViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var friendsList : [User] = []
    @Published var friendsGardens: [UserGarden] = []
    
    static var shared = FriendsViewModel()
    
    let gardenRepository = GardenRepository.shared
    let userRepo = UserRepository.shared
    let collections = Collections.shared
    
    var users: [User] = []
    var items: [GardenItem] = []
    
    let nc = NotificationCenter.default
    
    // MARK: Methods
    init(){
        fetchAllUsers()
        fetchAllCurrentItems()
    }
    
    func fetchAllUsers(){
        let userID = getUserID()
        guard let userID = userID else { return }
        userRepo.fetchAllUsers(userID: userID) { users in
            self.users = users
        }
    }
    
    func fetchAllCurrentItems(){
        
        let collection = self.collections.getCollectionReference(CollectionName.gardenItems.rawValue)
        guard let collection = collection else { return }
        let query = collection.whereField("date", isEqualTo: Date.today)
        
        self.gardenRepository.getUserItems(query: query) { items in
            self.items = items
            self.createFriendsGardens()
        }
    }
    
    func createFriendsGardens(){
        var dict: [String: [GardenItem]] = [:]
        var gardens: [UserGarden] = []
        
        for user in users {
            dict[user.id] = []
        }
    
        for item in items {
            guard dict[item.userID] != nil else { continue }
            dict[item.userID]!.append(item)
        }
        
        for user in users {
            let garden = UserGarden(user: user, items: dict[user.id]!)
            gardens.append(garden)
        }
        
        DispatchQueue.main.async {
            self.friendsGardens = gardens
        }
    }
}
