//
//  Message.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/07/2022.
//

import Foundation

protocol Messageable: Identifiable, Codable  {
    var id: String { get }
    var senderID: String { get }
    var senderName: String { get }
    var date: Date { get }
    var text: String { get }
}

struct Message: Messageable {
    var id: String = UUID().uuidString
    var senderID: String
    var senderName: String
    var receiverID: String
    var receiverName: String
    var receiverFcmToken: String
    var text: String
    var isPrivate = true
    var date: Date
    var senderFlower: String
}

struct CommunityMessage: Messageable {
    var id: String = UUID().uuidString
    var senderID: String
    var senderName: String
    var date: Date
    var group: Int
    var isPrivate: Bool
    var text: String
}



