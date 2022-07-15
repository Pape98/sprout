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
}

struct UserGarden: Identifiable {
    var id: String { UUID().uuidString }
    var user: User
    var items: [GardenItem]
}
