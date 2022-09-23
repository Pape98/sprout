//
//  AppViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 13/07/2022.
//

import Foundation
import FirebaseAuth

class AppViewModel: ObservableObject {
    static let shared = AppViewModel()
    let nc = NotificationCenter.default
    
    @Published var backgroundImage: String = "intro-bg"
    @Published var backgroundColor: String = "day"
    
    init(){
        nc.addObserver(self,
                       selector: #selector(setUserProfile),
                       name: Notification.Name(NotificationType.UserLoggedIn.rawValue),
                       object: nil)
        
        setBackground()
    }
    
    @objc func setUserProfile(){
        let currentUser = Auth.auth().currentUser!
        let user = User(id: currentUser.uid, name: currentUser.displayName ?? "", email: currentUser.email ?? "")
        UserService.user = user
    }
    
    func setBackground(){
        
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.hour], from: date)
        let hour = dateComponents.hour!
        
        var image = backgroundImage
        var color = backgroundColor
        
        if hour >= 0 && hour <= 6 { // night
            image = "night-bg"
            color = "night"
        } else if hour >= 7 && hour <= 10 { // morning
            image = "intro-bg"
            color = "morning"
        } else if hour >= 11 && hour <= 19 { // day
            image = "intro-bg"
            color = "day"
        } else { // evening
            image = "evening-bg"
            color = "evening"
        }
        
        DispatchQueue.main.async {
            self.backgroundImage = image
            self.backgroundColor = color
        }
    }
    
    
}