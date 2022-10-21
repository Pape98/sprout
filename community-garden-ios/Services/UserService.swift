//
//  UserService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/7/21.
//

import Foundation

// Singleton Class to represent logged in user
final class UserService {
    
    static var shared = UserService()
    var user = User()
        
    private init() {}
}
