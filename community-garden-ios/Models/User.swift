//
//  User.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

class User: Identifiable {
    
    // Profile Info
    var id: String = ""
    var name: String = ""
    var email: String = ""
    
    // Tracked Data
    var steps: [Step] = [Step]()
    
}
