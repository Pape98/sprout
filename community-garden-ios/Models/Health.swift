//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Step: Identifiable, Codable {
    var id: String { UUID().uuidString }
    var date: String
    var count: Double
    var userID: String
}

struct Sleep: Identifiable, Codable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
}

struct Workout: Identifiable, Codable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
}

struct WalkingRunningDistance: Identifiable, Codable {
    var id: String { UUID().uuidString }
    var date: String
    var distance: Double
    var userID: String
}
