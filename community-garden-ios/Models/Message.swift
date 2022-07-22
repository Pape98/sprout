//
//  Message.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/07/2022.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String = UUID().uuidString
    var senderID: String
    var sendderName: String
    var receiverID: String
    var message: String
    var isPrivate = false
}

struct MessageOption: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var text: String
    var color: String
    var isDefault: Bool = false
}
