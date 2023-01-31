//
//  Elements.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import Foundation

struct UserGarden: Identifiable {
    var id: String { UUID().uuidString }
    var user: User
    var items: [GardenItem]
}

enum GardenItemType: String, Codable {
    case tree
    case flower
}

struct GardenItem: Identifiable, Codable {
    var id: String { UUID().uuidString }
    var userID: String
    var type: GardenItemType
    var name: String
    var x: Double = 0 // Proportion
    var y: Double = 0 // Proportion
    var scale: Double = 1
    var date =  Date.today
    var documentName: String?
    var group: Int = 0
    var gardenName = ""
    var userName = ""
}
