//
//  Constants.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import HealthKit
import SwiftUI

struct Constants {
    
    static let clientID = "987260271190-lt53tt7akbciedliq2mdno33jpg08eb2.apps.googleusercontent.com"
    
    // Garden Items
    static let flowers = ["abyss-sage", "joyful-clover","savage-morel"]
    static let trees = ["spiky-maple", "whomping-medlar", "serpent-sumac","sad-holly","sneezy-cypress","tickle-beech","royal-larch","chilling-leaf"]
    static let colors = ["moss","cosmos","sunglow","grenadier","hawks","tangerine","lavender","mint","raspberry","porcelain"]
}

enum MappingKeys: String {
    case TREE = "Tree"
    case FLOWER = "Flower"
}

enum GardenElement: String {
    case droplet
    case seed
    case animal
    case tree
    case flower
}

enum DataOptions: String, CaseIterable {
    case steps = "Steps"
//    case exerciseMinute = "Exercise Minute"
    case sleep = "Sleep"
    case walkingRunningDistance = "Walking+running Distance"
    case workouts = "Workout Time"
    
    static var dalatList: [String] {
        return DataOptions.allCases.map { $0.rawValue }
      }
    
    static let icons = ["Steps":["figure.walk","🦶🏻Daily number of steps."],
                        "Sleep":["bed.double.circle","🛌🏽 Amount of time in bed."],
                        "Walking+running Distance":["bed.double.circle","🚶 Distance you walk or run."],
                        "Workout Time": ["bed.double.circle","🚴‍♀️ The number of workout minutes"]
    ]
}

enum Statistics: String, CaseIterable {
    case numDroplets = "numDroplets"
    case numSeeds = "numSeeds"
    
    static var list:[String] {
        Statistics.allCases.map { $0.rawValue}
    }
}

struct GoalsSettings {
    static let ranges: [String: ClosedRange<Float>] = [
        "Steps": 0...20000,
        "Sleep": 0...12,
        "Workout Time": 0...300,
        "Walking+running Distance": 1...50
    ]
    
    static let steps: [String: Float] = [
        "Steps": 500,
        "Sleep": 1,
        "Workout Time": 10,
        "Walking+running Distance": 1
    ]
    
    static let labels = [
        "Steps": "Step(s)",
        "Sleep": "Hour(s)",
        "Workout Time": "Minute(s)" ,
        "Walking+running Distance": "Mile(s)"
    ]
    
    static let titles = [
        "Steps": "Steps 🦶🏻",
        "Sleep": "Sleep 🛌🏽",
        "Workout Time": "Workout Time 🚴‍♀️",
        "Walking+running Distance": "Walking + Running Distance 🚶"
    ]
    
    static let defaultsKeys = [
        "Steps": FirestoreKey.STEPS_GOAL,
        "Sleep": FirestoreKey.SLEEP_GOAL,
        "Workout Time": FirestoreKey.WORKOUT_GOAL,
        "Walking+running Distance": FirestoreKey.WALKING_RUNNING_GOAL
    ]
}

enum SettingsMode: String {
    case treeType
    case flowerType
    case treeColor
    case flowerColor
}





