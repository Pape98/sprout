//
//  User.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class User: Identifiable, Codable, CustomStringConvertible {

    // Profile Info
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var oldStepCount: Int = 0
    
    var description: String {
        return "User(\(id),\(name),\(email),\(oldStepCount))"
    }
    
    // Tracked Data
    var steps: [Step]?
    
}
