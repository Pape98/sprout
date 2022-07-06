//
//  Statistics.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 06/07/2022.
//

import Foundation

struct Stat: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var value: Double = 0
}

struct Progress: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var new: Double = 0
    var old: Double = 0
}

