//
//  Analytics.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 31/08/2022.
//

import Foundation
import FirebaseAnalytics

class SproutAnalytics {
    
    init(){
        Analytics.logEvent(AnalyticsEventLogin, parameters: [
            AnalyticsParameterMethod: log
        ])
    }
    
    func log(){
        print("Login Event")
    }
}
