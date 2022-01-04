//
//  NotificationService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/3/22.
//

import Foundation
import UserNotifications

class NotificationService {
    
    init() {
        // Request authorization to send local notifications (for reminder purposes)
        let center = UNUserNotificationCenter.current()
        
        // Step 1: Ask for permission
        center.requestAuthorization(options: [.alert, .sound]) { isGranted, error in
            guard error == nil else {
                print("requestAuthorizations()", error!)
                return
            }
        }
        
        // Step 2: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Message from Community Garden"
        content.body = "Hello there! How are you feeling?"
        content.sound = UNNotificationSound.default
        
        // Step 3: Create the notification trigger

        let date =  "21:02:00".convertToDateObject(format: "HH:mm:ss")
        let dateComponents = Calendar.current.dateComponents([.hour,.minute, .second], from: date!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
            
        // Step 4: Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content,
                                            trigger: trigger)
    
        // Step 5: Register with notification center
        center.add(request) { error in
            
            if let error = error {
                print("[NOTIFICATION ERROR] ", error)
            }
        }
        
    }
}
 
