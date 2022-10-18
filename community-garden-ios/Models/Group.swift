//
//  Group.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/09/2022.
//

import Foundation

struct GardenGroup: Codable {
    var id: Int
    var flowers: [String: [Int]] = [
        "cosmos": [0,0,0],
        "grenadier": [0,0,0],
        "hawks": [0,0,0],
        "lavender": [0,0,0],
        "mint": [0,0,0],
        "porcelain": [0,0,0],
        "raspberry": [0,0,0],
        "sunglow": [0,0,0],
        "tangerine": [0,0,0],
    ]
    var fiftyPercentDays: Int? = 0
}

struct GoalsStat: Codable {
    var numberOfGoalsAchieved: Int = 0
    var date: String
    var group: Int
    var trackedData: [String] = []
}

struct Reactions: Codable {
    var group: Int = 0
    var date: String = ""
    var love: Int?
    var encouragement: Int?
}

struct NotificationMessage {
    var title: String = ""
    var body: String = ""
}

struct CommunityBadge: Hashable {
    var name: String
    var description: String = ""
    var numberOfDaysRequired = 2
}
