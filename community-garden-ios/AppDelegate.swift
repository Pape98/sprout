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
        
        
        // Styling
        UITableView.appearance().backgroundColor = .clear
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.appleGreen)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UIApplication.shared.registerForRemoteNotifications()
        
        // Toolbar title
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.hour], from: date)
        let hour = dateComponents.hour!
        var toolbarFontColor = UIColor.black
        
        if hour >= 0 && hour <= 6 {
            toolbarFontColor = UIColor.white
        }
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: toolbarFontColor ]
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("ERROR: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MessagesViewModel.shared.getUserMessages()
        
        guard let userInfo = userInfo as NSDictionary? as? [String: Any] else {
            completionHandler(UIBackgroundFetchResult.newData)
            return
        }
        
        var message = NotificationMessage()
        
        if let type = userInfo["type"] {
            
            if type as! String == "encouragement" {
                message.title = "Community Encouragement 🌟"
                message.body  = "You got this 🌟!"
            } else {
                message.title = "Community Love 💖"
                message.body  = "We love you 💖"
            }
            
            NotificationService.shared.sendNotification(message: message)
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            print("fcm",fcmToken)
            UserDefaultsService.shared.save(value: fcmToken, key: UserDefaultsKey.FCM_TOKEN)
            
            // Subscribe to group topic
            let groupNumber = UserService.user.group
            let group = "group\(groupNumber)"
            
            Messaging.messaging().subscribe(toTopic: group) { error in
                if let error = error {
                    print(error)
                    return
                }
                print("Subscribed to weather topic \(group)")
            }
            
        }
        
        if let userID = getUserID(), let token = fcmToken {
            if UserService.user.fcmToken == fcmToken { return }
            userRepository.doesUserExist(userID: userID) { userExists in
                guard let userExists = userExists else {
                    print("User does not exist so cannot set FCM Token")
                    return
                }
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
    }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        MessagesViewModel.shared.getUserMessages()
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
    }
}
