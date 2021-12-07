//
//  UserService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/7/21.
//

import Foundation

// Singleton Class

class UserService {
    
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
}
