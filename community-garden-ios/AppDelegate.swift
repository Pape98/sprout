//
//  AppDelegate.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/08/2022.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import FirebaseFunctions

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var userRepository: UserRepository
    
    override init() {
        self.userRepository = UserRepository.shared
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Messaging.messaging().delegate = self
        
        UITableView.appearance().backgroundColor = .clear
        UIApplication.shared.registerForRemoteNotifications()
                    
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("ERROR: \(error)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken)
        if let userID = getUserID(), let token = fcmToken {
            userRepository.updateUser(userID: userID, updates: ["fcmToken": token]) {}
        }
        
    }
}
