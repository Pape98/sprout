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
    
    func sendMessage(_ message: any Messageable, collectionName: CollectionName, completion: @escaping () -> Void){
        let collection = collections.getCollectionReference(collectionName.rawValue)
        
        guard let collection = collection else { return }
        
        do {
            try collection.document(message.id).setData(from: message){ error in
                if let error = error {
                    Debug.log.debug(error)
                    return
                }
                completion()
            }
                      
        } catch let error {
            Debug.log.error("Error sending message to Firestore: \(error)")
        }

    }
    
    func getMessages<T:Messageable>(query: Query, type: T.Type, completion: @escaping ([T]) -> Void){
        query.getDocuments { querySnapshot, error in
            
            if error != nil {
                Debug.log.error("getMessages: Error reading from Firestore: \(error!)")
                return
            }
            
            var messages: [T] = []
            
            do {
                for doc in querySnapshot!.documents {
                    messages.append(try doc.data(as: T.self))
                }
            } catch {
                Debug.log.error("getUserItems: Error reading from: \(error)")
            }
            
            completion(messages)
        }
    }
}
