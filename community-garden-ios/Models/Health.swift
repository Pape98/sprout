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
    var statusCount: Double { get }
    var date: String { get set }
}

struct Step: HealthData {
    var id: String { UUID().uuidString }
    var date: String
    var count: Double
    var userID: String
    
    var statusCount: Double {
        count
    }
}

struct Sleep: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
    
    var statusCount: Double {
        duration
    }
}

struct Workout: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var duration: Double
    var userID: String
    
    var statusCount: Double {
        duration
    }
}

struct WalkingRunningDistance: HealthData, Identifiable {
    var id: String { UUID().uuidString }
    var date: String
    var distance: Double
    var userID: String
    
    var statusCount: Double {
        distance
    }
}
