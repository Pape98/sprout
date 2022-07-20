//
//  UserService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/7/21.
//

import Foundation

// Singleton Class to represent logged in user
class UserService {
    
    static var user = User()
        
    private init() {}
}
