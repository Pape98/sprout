//
//  AppViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 13/07/2022.
//

import Foundation
import FirebaseAuth

class AppViewModel: ObservableObject {
    static let shared = AppViewModel()
    let nc = NotificationCenter.default
    
    init(){
        nc.addObserver(self,
                       selector: #selector(setUserProfile),
                       name: Notification.Name(NotificationType.UserLoggedIn.rawValue),
                       object: nil)
    }
    
    @objc func setUserProfile(){
        let currentUser = Auth.auth().currentUser!
        let user = User(id: currentUser.uid, name: currentUser.displayName ?? "", email: currentUser.email ?? "")
        UserService.user = user
    }
    
    
}
