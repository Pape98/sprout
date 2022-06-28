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
    case sleep = "Sleep"
    
    static var dalatList: [String] {
        return DataOptions.allCases.map { $0.rawValue }
      }
    
    static let icons = ["Steps":["figure.walk","🚶 Your daily number of steps"],
                        "Sleep":["bed.double.circle","🛌🏽 Amount you are in bed asleep"]]
}

struct GoalsSettings {
    static let ranges: [String: ClosedRange<Float>] = [
        "Steps": 0...20000,
        "Sleep": 0...24
    ]
    
    static let steps: [String: Float] = [
        "Steps": 500,
        "Sleep": 1
    ]
    
    static let labels = [
        "Steps": "Step(s)",
        "Sleep": "Hour(s)"
    ]
    
    static let titles = [
        "Steps": "Steps 🚶",
        "Sleep": "Sleep 🛌🏽"
    ]
    
    static let defaultsKeys = [
        "Steps": UserDefaultsKey.STEPS_GOAL,
        "Sleep": UserDefaultsKey.SLEEP_GOAL
    ]
}





