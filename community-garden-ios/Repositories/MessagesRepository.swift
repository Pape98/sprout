//
//  MessageRepository.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/07/2022.
//

import Foundation
import FirebaseFirestore

class MessagesRepository {
    static let shared = MessagesRepository()
    let collections = Collections.shared
    
    func sendMessage(_ message: Message){
        let collection = collections.getCollectionReference(CollectionName.messages.rawValue)
        
        guard let collection = collection else { return }
        
        do {
            try collection.document(message.id).setData(from: message)
        } catch let error {
            print("Error sending message to Firestore: \(error)")
        }

    }
    
    func getMessages(query: Query, completion: @escaping ([Message]) -> Void){
        query.getDocuments { querySnapshot, error in
            
            if error != nil {
                print("getMessages: Error reading from Firestore: \(error!)")
                return
            }
            
            var messages: [Message] = []
            
            do {
                for doc in querySnapshot!.documents {
                    messages.append(try doc.data(as: Message.self))
                }
            } catch {
                print("getUserItems: Error reading from: \(error)")
            }
            
            completion(messages)
        }
    }
}
