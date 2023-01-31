//
//  MessagingService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 06/10/2022.
//

import Foundation
import Firebase
import FirebaseMessaging

class MessagingService {
    static let shared = MessagingService()
    let nc = NotificationCenter.default
    
    init(){}
    
    func subscribeToTopic(_ topic: String){
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                Debug.log.error(error)
                return
            }
            Debug.log.info("Subscribed to topic \(topic)")
        }
    }
    
    func unsubscribeFromTopic(topic: String){
        
        Messaging.messaging().unsubscribe(fromTopic: topic) { err in
            if let error = err {
                Debug.log.error("Messaging error: \(error.localizedDescription)")
                return
            } else {
                Debug.log.info("Unsubscribed from \(topic)")

            }
        }
    }
    
    func unsubscribeFromAllTopics(){
        for i in 0...3 {
            unsubscribeFromTopic(topic: "group\(i)")
        }        
    }
}
