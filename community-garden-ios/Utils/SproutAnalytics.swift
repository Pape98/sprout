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
        setDefaultParams()
    }
    
    func setDefaultParams(){
        if let user = Auth.auth().currentUser {
            let parameters: [String: Any] = ["userID": user.uid,
                                             "name": user.displayName ?? "No Name", "timestamp": Date().timeIntervalSince1970,
                                             "group": UserService.shared.user.group]
            Analytics.setUserID(user.uid)
            Analytics.setDefaultEventParameters(parameters)
        }
    }
        
    // Screen views
    func viewOwnGarden(){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent(AnalyticsEventScreenView, parameters: ["screen": "own_garden"])
    }
    
    func viewCommunity(){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent(AnalyticsEventScreenView, parameters: ["screen": "community"])
    }
    
    func viewHistory(){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent(AnalyticsEventScreenView, parameters: ["screen": "history"])
    }
    
    func viewBadges(){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent(AnalyticsEventScreenView, parameters: ["screen": "badges"])
    }
    
    func viewIndividualHistoryPage(data: String, date: String){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent(AnalyticsEventScreenView, parameters: ["screen": "individual_history", "data" : data, "date": date])
    }
    
    // Droplet & Seeds
    
    func gainingDroplets(numDroplet: Int){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent("gaining_droplets", parameters: ["dropletCount": numDroplet])
    }
    
    func gainingSseeds(numSeed: Int){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent("gaining_seeds", parameters: ["seedCount": numSeed])
    }
    
    func useDroplet(){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent("use_droplet", parameters: nil)
    }
    
    func useSeed(){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent("use_seed", parameters: nil)
    }
    
    
    // Messages
    func individualMessage(senderID: String, senderName: String, receiverID: String, receiverName: String, content: String, isPrivate: Bool, group: Int){
        guard isUserLoggedIn() == true else { return }
        let params: [String: Any] = ["senderID": senderID,
                                     "senderName": senderName,
                                     "receiverID": receiverID,
                                     "receiverName": receiverName,
                                     "content": content,
                                     "isPrivate": isPrivate,
                                     "group": group]
        Analytics.logEvent("individual_message", parameters: params)
    }
    
    func groupMessage(message: [String: Any]){
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent("group_message", parameters: message)
    }
    
    // Customization
    func appCustomization(type: String){ // what was customized
        guard isUserLoggedIn() == true else { return }
        Analytics.logEvent("app_customization", parameters: ["type": type])
    }
    
    func goalChange(goal: String, old: Float, new: Float){
        guard isUserLoggedIn() == true else { return }
        let params : [String: Any] = ["goal": goal, "old": old, "new": new]
        Analytics.logEvent("goal_change", parameters: params)
    }
    
}

