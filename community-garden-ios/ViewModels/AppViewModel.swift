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
    
    @Published var backgroundImage: String = "night-bg"
    @Published var backgroundColor: String = "night"
    @Published var fontColor: Color = .black
    @Published var showPointsGainedAlert = false
    @Published var numFiftyPercentDays = 0
    
    var alertImage = ""
    var alertTitle = ""
    var alertSubtitle = ""
    
    init(){
        nc.addObserver(self,
                       selector: #selector(setUserProfile),
                       name: Notification.Name(NotificationType.UserLoggedIn.rawValue),
                       object: nil)
        
        setBackground()
        setNumFiftyPercentDays()
    }
    
    func setNumFiftyPercentDays() {
        let userGroup = UserService.shared.user.group
        groupRepository.fetchGroup(groupNumber: userGroup) { group in
            if let numFiftyPercentDays = group.fiftyPercentDays {
                self.numFiftyPercentDays = numFiftyPercentDays
            }
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
    
    
}
