//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseFirestoreSwift


struct Step: Codable {
    var date: String
    var count: Double
}

struct Sleep: Identifiable, Codable {
    var id: String? = UUID().uuidString
    var date: String
    var duration: Double
}

struct Workout: Identifiable, Codable {
    var id: String? = UUID().uuidString
    var date: String
    var duration: Double
}

struct WalkingRunningDistance: Identifiable, Codable {
    var id: String? = UUID().uuidString
    var date: String
    var distance: Double
}
