//
//  Elements.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import Foundation

enum GardenItemType: String {
    case tree1 = "tree1"
}

struct GardenItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var height: Double
}
