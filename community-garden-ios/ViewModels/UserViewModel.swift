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
    @Published var currentUser: User!
    
    static var shared = UserViewModel()
    
    let userRepository = UserRepository.shared
    
    // MARK: - Methods
    
    init() {
    
        /* Check if user meta data has been fetched.
         If the user was already logged in from a previous session,
         we need to get their data in a separate call */
        
    }
}
