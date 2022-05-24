//
//  User.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, CustomStringConvertible {

    // Profile Info
    @DocumentID var id: String? = ""
    var name: String = ""
    var email: String = ""
    var oldStepCount = 0
    var stepCount: Step?
    var numDroplets: Int = 0
    
    
    var description: String {
        return "User(\(id!),\(name),\(email),\(String(describing: stepCount?.count)),\(numDroplets)"
    }
    
}
