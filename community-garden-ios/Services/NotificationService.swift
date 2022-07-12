//
//  NotificationService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/3/22.
//

import Foundation
import UserNotifications

class NotificationService {
    
    var center: UNUserNotificationCenter
    
    init() {
        // Request authorization to send local notifications (for reminder purposes)
        center = UNUserNotificationCenter.current()
        center.
        
        // Ask for permission
        center.requestAuthorization(options: [.alert, .sound]) { isGranted, error in
            guard error == nil else {
                print("requestAuthorizations()", error!)
                return
            }
        }
        
        setupHowAreYouNotification()
    }
    
    func setupHowAreYouNotification() {
        // Step 1: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Message from Community Garden"
        content.body = "Hello there! How are you feeling?"
        content.sound = UNNotificationSound.default
        
        // Step 2: Create the notification trigger

        let date =  "21:10:00".convertToDateObject(format: "HH:mm:ss")
        let dateComponents = Calendar.current.dateComponents([.hour,.minute, .second], from: date!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
            
        // Step 3: Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content,
                                            trigger: trigger)
    
        // Step 4: Register with notification center
        center.add(request) { error in
            
            if let error = error {
                print("[NOTIFICATION ERROR] ", error)
            }
        }
    }
}
 
