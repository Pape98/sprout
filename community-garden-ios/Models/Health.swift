//
//  Health.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import FirebaseFirestoreSwift

protocol HealthData: Codable {
    var id: String { get } 
    var textDisplay: String { get }
    var value: Double { get }
    var date: String { get set }
    var label: String { get }
    var goal: Int? { get }
}

struct Step: HealthData {
    var id: String { UUID().uuidString }
    var date: String
    var count: Double
    var userID: String
    var goal: Int?
    
    var value: Double { count }
    var textDisplay: String { "\(Int(count)) Step(s)" }
    var label: String { "step" }
}

struct Sleep: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
    var goal: Int?
    
    var value: Double { duration }
    var textDisplay: String { "\(Int(duration)/60) Hour(s)" }
    var label: String { "sleep" }
}

struct Workout: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
    var goal: Int?
    
    var value: Double { duration }
    var textDisplay: String { "\(Int(duration)) Minute(s)" }
    var label: String { "workout" }
}

struct WalkingRunningDistance: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var distance: Double
    var userID: String
    var goal: Int?
    
    var value: Double { distance }
    var textDisplay: String { "\(distance.truncate(to: 2)) Mile(s)" }
    var label: String { "walkingRunning" }
}
