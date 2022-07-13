//
//  Elements.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import Foundation

enum GardenItemType: String, Codable {
    case tree
    case flower
}

struct GardenItem: Identifiable, Codable {
    var id: String { UUID().uuidString }
    var type: GardenItemType
    var name: String
    var x: Double = 0 // Proportion
    var y: Double = 0 // Proportion
    var scale: Double = 1
}
