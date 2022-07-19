//
//  User.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var group: Int = 0
    var hasBeenOnboarded = false
    var settings: UserSettings?
}

struct UserGarden: Identifiable {
    var id: String { UUID().uuidString }
    var user: User
    var items: [GardenItem]
}

struct UserSettings: Codable {
    var data: [String] = []

    var flower: String = ""
    var flowerColor: String = ""
    var tree: String = ""
    var treeColor: String = ""
    
    var gardenName = ""
    var reflectWeatherChanges = true
    
    var sleepGoal: Int?
    var stepsGoal: Int?
    var walkingRunningGoal: Int?
    var workoutsGoal: Int?
    
}
