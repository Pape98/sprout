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
    var goalDisplay: String { get }
    var value: Double { get }
    var date: String { get set }
    var label: String { get  }
    var goal: Int? { get set }
    var username: String { get set }
    var group: Int { get set }
    var hasReachedGoal: Bool? { get set }
}

struct Step: HealthData {    
    var id: String { UUID().uuidString }
    var date: String
    var count: Double
    var userID: String
    var goal: Int?
    var username: String
    var group: Int
    var hasReachedGoal: Bool?
    
    var value: Double { count }
    var textDisplay: String { "\(Int(count)) step(s)" }
    var goalDisplay: String { "\(Int(goal ?? 0))" }
    var label: String { "step" }
}

struct Sleep: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
    var goal: Int?
    var username: String
    var group: Int
    var hasReachedGoal: Bool?
    
    var value: Double { duration }
    var textDisplay: String { "\(duration.asString(style: .short))" }
    var goalDisplay: String { "\(Double(goal ?? 0).asString(style: .short))" }
    var label: String { "sleep" }
}

struct Workout: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
    var goal: Int?
    var username: String
    var group: Int
    var hasReachedGoal: Bool?
    
    var value: Double { duration }
    var textDisplay: String { "\(duration.asString(style: .short))"}
    var goalDisplay: String { "\(Double(goal ?? 0).asString(style: .short))" }
    var label: String { "workout" }
}

struct WalkingRunningDistance: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var distance: Double
    var userID: String
    var goal: Int?
    var username: String
    var group: Int
    var hasReachedGoal: Bool?
    
    var value: Double { distance }
    var textDisplay: String { "\(distance.truncate(to: 1)) mi" }
    var goalDisplay: String { "\(Double(goal ?? 0).truncate(to: 1)) mi" }
    var label: String { "walkingRunning" }
}
