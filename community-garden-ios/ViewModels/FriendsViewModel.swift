//
//  FriendsViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import Foundation

class FriendsViewModel: ObservableObject {
    
    // MARK: - Properties
    static var shared = FriendsViewModel()
    var userRepository: UserRepository = UserRepository.shared
    @Published var friendsList : [User] = []
    let nc = NotificationCenter.default
    
    init(){
        nc.addObserver(self, selector: #selector(self.getFriends), name: Notification.Name(NotificationType.UserLoggedIn.rawValue), object: nil)
    }
    
    // MARK: - Methods
    @objc
    func getFriends(){
//        let userID = UserService.shared.user.id
//        print("getfriends", userID)
//        userRepository.fetchAllUsers(userID: userID) { users in
//            print("friends",users)
//            self.friendsList = users
//        }
    }
}
