//
//  Constants.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import HealthKit

struct Constants {
    
    enum LoginMode {
        case login
        case createAccount
    }
 
    struct HKDataTypes {
        static let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)!
    }

}
