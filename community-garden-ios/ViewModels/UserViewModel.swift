//
//  HealthModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseAuth

class UserViewModel: ObservableObject {
    
    // MARK: - Properties
    
    // To access and edit loggedInUser
    var currentUser: User = UserService.shared.user

    // MARK: - Methods
    
    init() {
    
        /* Check if user meta data has been fetched.
         If the user was already logged in from a previous session,
         we need to get their data in a separate call */
        
        if let authUser = Auth.auth().currentUser {
            currentUser.name = authUser.displayName!
            currentUser.email = authUser.email!
            currentUser.id = authUser.uid
        }
    }
}
