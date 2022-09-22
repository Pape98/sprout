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

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var userRepository: UserRepository
    
    override init() {
        self.userRepository = UserRepository.shared
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UITableView.appearance().backgroundColor = .clear
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.appleGreen)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("ERROR: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        MessagesViewModel.shared.getUserMessages()
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let userID = getUserID(), let token = fcmToken {
            userRepository.doesUserExist(userID: userID) { userExists in
                guard let userExists = userExists else { return }
                if userExists {
                    self.userRepository.updateUser(userID: userID, updates: ["fcmToken": token]) {}
                }
            }
        }
    }
    
    // MARK: Notification Delegate Methods
    
    // This function will be called when the app receive notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        MessagesViewModel.shared.getUserMessages()
        // show the notification alert (banner), and with sound
        completionHandler([.banner,.sound])
        
        print("userNotificationCenter 1")
    }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        MessagesViewModel.shared.getUserMessages()
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
    }
}
