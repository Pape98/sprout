//
//  GardenViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/24/22.
//

import Foundation

class GardenViewModel: ObservableObject {
    
    static var shared: GardenViewModel = GardenViewModel()
    let userRepository = UserRepository.shared
    let TREE_SCALE_FACTOR = 0.03

    func handleDropletRelease(){
        let currentUser: User = UserService.shared.user
        let newNumDroplets = currentUser.numDroplets - 1
        let gardenItem = currentUser.gardenItems.first
    
        guard  gardenItem != nil else { return }
        
        let updates: [String: Any] = ["numDroplets": newNumDroplets,
                                      "gardenItems": [["id": gardenItem!.id, "name": "tree1", "height": Double(gardenItem!.height) + TREE_SCALE_FACTOR]]]
        
        userRepository.updateUser(userID: currentUser.id, updates: updates ) {
            NotificationSender.send(type: NotificationType.FetchUser.rawValue)
        }
    }
}
