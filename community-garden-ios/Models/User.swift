//
//  User.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

struct User: Identifiable, Codable {

    // Profile Info
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var oldStepCount = 0
    var stepCount: Step?
    var numDroplets: Int = 0
    var gardenItems: [GardenItem] = []
    
}
