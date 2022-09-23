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
}
