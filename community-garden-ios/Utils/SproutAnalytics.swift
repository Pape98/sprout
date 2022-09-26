//
//  SproutAnalytics.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 04/09/2022.
//

import Foundation
import FirebaseAnalytics
import FirebaseAuth

class SproutAnalytics {
    
    static let shared = SproutAnalytics()
    
    init(){
        if let user = Auth.auth().currentUser {
            let parameters: [String: Any] = ["userID": user.uid, "name": user.displayName ?? "No Name", "timestamp": Date().timeIntervalSince1970]
            Analytics.setUserID(user.uid)
            Analytics.setDefaultEventParameters(parameters)
            Analytics.setUserProperty("group-\(UserService.user.group)", forName: "group")
        }
    }
    
    func appLaunch(){
        Analytics.logEvent("app_launch", parameters: nil)
    }
    
    // Screen views
    func viewOwnGarden(){
        Analytics.logEvent(AnalyticsEventScreenView, parameters: ["screen": "own_garden"])
    }
    
    func viewCommunity(){
        Analytics.logEvent(AnalyticsEventScreenView, parameters: ["screen": "community"])
    }
    
    func viewHistory(){
        Analytics.logEvent(AnalyticsEventScreenView, parameters: ["screen": "history"])
    }
    
    // Customization
    func appCustomization(type: String){ // what was customized
        Analytics.logEvent("app_customization", parameters: ["type": type])
    }
    
}

class AnalyticsTimer {
    
    var timer: Timer?
    var count = 0
    
    func start() {
        timer =
        Timer.scheduledTimer(withTimeInterval:1.0, repeats: true) { _ in
            self.count = self.count + 1
        }
    }
    
    func stop(){
        timer?.invalidate()
        timer = nil
    }
    
    func reset(){
        count = 0
    }
    
}

