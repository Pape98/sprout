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
            let parameters: [String: Any] = ["userID": user.uid,
                                             "name": user.displayName ?? "No Name", "timestamp": Date().timeIntervalSince1970,
                                             "group": UserService.user.group
            ]
            Analytics.setUserID(user.uid)
            Analytics.setDefaultEventParameters(parameters)
//            Analytics.setUserProperty("group-\(UserService.user.group)", forName: "group")
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
    
    // Droplet & Seeds
    
    func gainingDroplets(numDroplet: Int){
        Analytics.logEvent("gaining_droplets", parameters: ["dropletCount": numDroplet])
    }
    
    func gainingSseeds(numSeed: Int){
        Analytics.logEvent("gaining_seeds", parameters: ["seedCount": numSeed])
    }
    
    func useDroplet(){
        Analytics.logEvent("use_droplet", parameters: nil)
    }
    
    func useSeed(){
        Analytics.logEvent("use_seed", parameters: nil)
    }
    
    
    // Messages
    func individualMessage(senderID: String, senderName: String, receiverID: String, receiverName: String){
        let params = ["senderID": senderID, "senderName": senderName, "receiverID": receiverID, "receiverName": receiverName]
        Analytics.logEvent("individual_message", parameters: params)
    }
    
    func groupMessage(senderID: String, senderName: String, type: ReactionType){
        let params : [String: Any] = ["senderID": senderID, "senderName": senderName, "type": type.rawValue]
        Analytics.logEvent("group_message", parameters: params)
    }
    
    // Customization
    func appCustomization(type: String){ // what was customized
        Analytics.logEvent("app_customization", parameters: ["type": type])
    }
    
}

