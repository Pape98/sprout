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

enum DataOptions: String, CaseIterable {
    case steps = "Steps"
    case exerciseMinute = "Exercise Minute"
    case sleep = "Sleep"
    case walkingRunningDistance = "Walking + Running Distance"
    
    static var dalatList: [String] {
        return DataOptions.allCases.map { $0.rawValue }
      }
    
    static let icons = ["Steps":["figure.walk","🦶🏻Daily number of steps."],
                        "Sleep":["bed.double.circle","🛌🏽 Amount of time in bed."],
                        "Exercise Minute":["bed.double.circle","🚴‍♀️ Anything more than brisk walk."],
                        "Walking + Running Distance":["bed.double.circle","🚶 Distance you walk or run."],
    ]
}

struct GoalsSettings {
    static let ranges: [String: ClosedRange<Float>] = [
        "Steps": 0...20000,
        "Sleep": 0...12,
        "Exercise Minute": 0...500,
        "Walking + Running Distance": 1...50
    ]
    
    static let steps: [String: Float] = [
        "Steps": 500,
        "Sleep": 1,
        "Exercise Minute": 10,
        "Walking + Running Distance": 1
    ]
    
    static let labels = [
        "Steps": "Step(s)",
        "Sleep": "Hour(s)",
        "Exercise Minute": "Minute(s)" ,
        "Walking + Running Distance": "Mile(s)"
    ]
    
    static let titles = [
        "Steps": "Steps 🦶🏻",
        "Sleep": "Sleep 🛌🏽",
        "Exercise Minute": "Exercise Minute 🚴‍♀️",
        "Walking + Running Distance": "Walking + Running Distance 🚶"
    ]
    
    static let defaultsKeys = [
        "Steps": UserDefaultsKey.STEPS_GOAL,
        "Sleep": UserDefaultsKey.SLEEP_GOAL,
        "Exercise Minute": UserDefaultsKey.EXERCISE_GOAL,
        "Walking + Running Distance": UserDefaultsKey.WALKING_RUNNING_GOAL
    ]
}





