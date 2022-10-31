//
//  AppViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 13/07/2022.
//

import Foundation
import FirebaseAuth
import SwiftUI

class AppViewModel: ObservableObject {
    static let shared = AppViewModel()
    let nc = NotificationCenter.default
    let groupRepository = GroupRepository.shared
    let remoteConfig = RemoteConfiguration.shared
    
    @Published var backgroundImage: String = "night-bg"
    @Published var backgroundColor: String = "night"
    @Published var fontColor: Color = .black
    @Published var showPointsGainedAlert = false
    @Published var numFiftyPercentDays = 0
    @Published var introBackground = "intro-bg-day"
    
    @Published var isSocialConfig = true
    @Published var canCustomize = true
    
    var alertImage = ""
    var alertTitle = ""
    var alertSubtitle = ""
    
    init(){
        nc.addObserver(self,
                       selector: #selector(setUserProfile),
                       name: Notification.Name(NotificationType.UserLoggedIn.rawValue),
                       object: nil)
        
        setBackground()
        setIntroBackground()
        setNumFiftyPercentDays()
    }
    
    func isBadgeUnlocked(_ badge: UnlockableBadge) -> Bool {
        let groupNumber = UserService.shared.user.group
        if remoteConfig.isSocialConfig(group: groupNumber) == false {
            return true
        }
        let minimunNumDays = Constants.badges[badge]!.numberOfDaysRequired
        return numFiftyPercentDays >= minimunNumDays
    }
    
    func isSocialConfigGroup(){
        remoteConfig.fetchRemoteConfig()
        let groupNumber = UserService.shared.user.group
        DispatchQueue.main.async {
            self.isSocialConfig = self.remoteConfig.isSocialConfig(group: groupNumber)
        }
    }
    
    func isCustomizationGroup(){
        remoteConfig.fetchRemoteConfig()
        let groupNumber = UserService.shared.user.group
        DispatchQueue.main.async {
            self.canCustomize = self.remoteConfig.canCustomize(group: groupNumber)
        }
    }
    
    func setNumFiftyPercentDays() {
        let userGroup = UserService.shared.user.group
        groupRepository.fetchGroup(groupNumber: userGroup) { group in
            self.numFiftyPercentDays = group.fiftyPercentDays
        }
    }
    
    func alertPointsGained(mappedElement: String, value: Double){
        alertImage = mappedElement == "Tree" ? "droplet" : "seed"
        let label = mappedElement == "Tree" ? "droplet(s)" : "seed(s)"
        alertSubtitle = " Make sure to use them 😊"
        alertTitle = "\(Int(value)) \(label)"
        
        DispatchQueue.main.async {
            self.showPointsGainedAlert = true
        }
    }
    
    @objc func setUserProfile(){
        let currentUser = Auth.auth().currentUser!
        let user = User(id: currentUser.uid, name: currentUser.displayName ?? "", email: currentUser.email ?? "")
        UserService.shared.user = user
    }
    
    
    func setBackground(){
        let hour = Date.hour
        
        var image = backgroundImage
        var color = backgroundColor
        
        if hour >= 0 && hour <= 6 { // night
            image = "night-bg"
            color = "night"
        } else if hour >= 7 && hour <= 10 { // morning
            image = "intro-bg"
            color = "morning"
        } else if hour >= 11 && hour < 18 { // day
            image = "intro-bg"
            color = "day"
        } else { // evening
            image = "evening-bg"
            color = "evening"
        }
        
        DispatchQueue.main.async {
            
            self.backgroundImage = image
            self.backgroundColor = color
            
            if self.backgroundColor == "night" || self.backgroundColor == "evening"  {
                self.fontColor = .white
            }
        }
    }
    
    func setIntroBackground() {
        let hour = Date.hour
                
        DispatchQueue.main.async {
            if hour >= 0 && hour <= 6 { // night
                self.introBackground = "intro-bg-night"
            } else if hour >= 7 && hour <= 10 { // morning
                self.introBackground = "intro-bg-morning"
            } else if hour >= 11 && hour < 18 { // day
                self.introBackground = "intro-bg-day"
            } else { // evening
                self.introBackground = "intro-bg-evening"
            }
        }
    }
}
