//
//  User.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

struct User: Identifiable, Codable, CustomStringConvertible {

    // Profile Info
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var stepCount: Step?
    var numDroplets: Int = 0
    
    var description: String {
        return "User(\(id),\(name),\(email),\(stepCount),\(numDroplets)"
    }
    
    // Tracked Data
    var steps: [Step]?
    
}
