//
//  Constants.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import HealthKit

struct Constants {
    
    static let clientID = "987260271190-lt53tt7akbciedliq2mdno33jpg08eb2.apps.googleusercontent.com"
    
    enum LoginMode: String {
        case login = "login"
        case signUp = "signUp"
    }
 
    struct HKDataTypes {
        static let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)!
    }

}
