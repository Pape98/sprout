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
    var date: String { get set }
}

struct Step: HealthData {
    var id: String { UUID().uuidString }
    var date: String
    var count: Double
    var userID: String
    
    var textDisplay: String { "\(Int(count)) Step(s)" }
}

struct Sleep: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
    
    var textDisplay: String { "\(Int(duration)/60) Hour(s)" }
}

struct Workout: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
    
    var textDisplay: String { "\(Int(duration)) Minute(s)" }
}

struct WalkingRunningDistance: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var distance: Double
    var userID: String
    
    var textDisplay: String { "\(distance.truncate(to: 2)) Mile(s)" }
}
