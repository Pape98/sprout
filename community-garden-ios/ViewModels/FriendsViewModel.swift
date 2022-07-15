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
    let nc = NotificationCenter.default
    
    // MARK: Methods
    init(){
        getFriendsGarden()
    }
        
    func getFriendsGarden(){
        let userID = getUserID()
        guard let userID = userID else { return }
        
        DispatchQueue.main.async {
            self.friendsGardens = []
        }

        userRepo.fetchAllUsers(userID: userID) { users in
            for user in users {
                let collection = self.collections.getCollectionReference(CollectionName.gardenItems.rawValue)
                guard let collection = collection else { return }
                let query = collection.whereField("userID", isEqualTo: user.id)
                                      .whereField("date", isEqualTo: Date.today)
                
                
                self.gardenRepository.getUserItems(query: query) { items in
                    let userGarden = UserGarden(user: user, items: items)
                    
                    DispatchQueue.main.async {
                        self.friendsGardens.append(userGarden)
                    }
                }
            }
        }
    }
}
