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
    var senderName: String
    var receiverID: String
    var receiverName: String
    var receiverFcmToken: String
    var text: String
    var isPrivate = false
    var date: Date
}

struct MessageOption: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var text: String
    var color: String
    var isDefault: Bool = false
}
