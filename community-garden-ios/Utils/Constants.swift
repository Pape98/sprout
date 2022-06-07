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
        
    static let moodTypes = [
        "happy": Color.green,
        "meh": Color.blue,
        "bad": Color.orange,
        "terrible": Color.red,
    ]
    
    static let clientID = "987260271190-lt53tt7akbciedliq2mdno33jpg08eb2.apps.googleusercontent.com"
    static let trees = ["spruce", "oak", "linden"]
    
}


struct HKDataTypes {
    static let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)!
    static let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)!
    static let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
}



