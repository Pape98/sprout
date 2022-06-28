//
//  NotificationSender.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/24/22.
//

import Foundation


enum NotificationType: String {
    case UserLoggedIn = "UserLoggedIn"
    case FetchUser = "FetchUser"
}

class NotificationSender {
    
    static func send(type: String){
        NotificationCenter.default.post(name: Notification.Name(type), object: nil)
    }
}
