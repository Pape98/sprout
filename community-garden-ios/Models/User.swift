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
    var group: Int = 0 // Group with no customize and no social
    var hasBeenOnboarded: Bool? = false
    var settings: UserSettings?
    var fcmToken: String = ""
    var lastReset: String = ""
}

struct UserSettings: Codable {
    var data: [String] = []
    var mappedData: [String: String] = [:]

    var flower: String = ""
    var flowerColor: String = ""
    var tree: String = ""
    var treeColor: String = ""
    
    var gardenName = ""
    var reflectWeatherChanges = true
    
    var sleepGoal: Int? = 0
    var stepsGoal: Int? = 0
    var walkingRunningGoal: Int? = 0
    var workoutsGoal: Int? = 0
    
}
