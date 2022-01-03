//
//  Database.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/7/21.
//

import Foundation
import Firebase

class DatabaseService {
    
    // Collection Names
    enum Collection: String {
        case users, steps, moods
    }
    
    // Single database instance shared
    static let shared = DatabaseService()
    
    // MARK: - Properties
    
    let db: Firestore
    let usersCollection: CollectionReference
    let moodsCollection: CollectionReference
    
    var doesUserExsist = false
    
    init() {
        
        // Get a reference to database
        db = Firestore.firestore()
        
        // Get collection references
        usersCollection = db.collection(Collection.users.rawValue)
        moodsCollection = db.collection(Collection.moods.rawValue)
    }
    
    
    // MARK: - Users
    
    func createNewUser(_ user: User) {
        
        let newUser: [String: Any] = ["id": user.id,
                                      "name": user.name,
                                      "email": user.email]
        
        usersCollection.document(user.id).setData(newUser){ err in
            if let err = err {
                print("[createNewUser()]","Error writing document: \(err)")
            }
        }
    }
    
    func doesUserExist(userID: String, completion: @escaping () -> Void) {
        
        // Get document reference
        let userRef = usersCollection.document(userID)
        
        // Check if user exists in database
        userRef.getDocument { document, error in
            
            guard error == nil else {
                print("[doesUserExist()]", error!)
                return
            }
            
            if let condition = document?.exists {
                self.doesUserExsist = condition
            }
            completion()
        }
        
    }
    
    // MARK: - Healthkit Data
    
    // TODO: Save date as timestamp and not String
    
    func updateUserTrackedData(userID: String, collection: Collection, update: [String: Any], completion: @escaping () -> Void) {
        
        // Get document reference
        let userRef = usersCollection.document(userID)
        
        guard let date = update["date"] as? Date else { return }
        
        // Perform update operation
        userRef
            .collection(Collection.steps.rawValue)
            .document(date.getFormattedDate(format: "MM-dd-YYYY"))
            .setData(update)

        completion()
    }
    
    func getUserSteps(userID: String, collection: Collection, completion: @escaping ([Step]) -> Void) {
        
        var fetchedData = [Step]()
        
        // Get a reference to the subcollection for data
        let subCollection = usersCollection
            .document(userID)
            .collection(collection.rawValue)
            .order(by: "date", descending: true)
        
        subCollection.getDocuments { snapshot, error in
            
            guard error == nil else {
                print("[getUserData()]", error!)
                return
            }
            
            for doc in snapshot!.documents {
                
                // TODO: Generalize to accept other data
                
                let item = Step()
                item.count = doc["count"] as? Int ?? 0
                                
                let date = doc["date"] as? Timestamp ?? nil
                
                if let dateValue = date {
                    item.date = dateValue.dateValue()
                }
                
                fetchedData.append(item)
            }
                        
            completion(fetchedData)
        }
    }
    
    // MARK: - Mood
    
    func addMoodEntry(text: String, date: Date, userId: String, completion: @escaping () -> Void) {
        
        
        let newMood: [String: Any] = ["id": UUID().uuidString,
                                      "text": text,
                                      "date": date,
                                      "userId": userId]
        
        moodsCollection.document().setData(newMood, merge: true){ error in
            if let error = error {
                print("Error writing document: \(error)")
            }
            
            completion()
        }
    }
    
    func getMoodEntries(userId: String, completion: @escaping ([Mood]) -> Void) {
        
        var currentUserMoods = [Mood]()
        
        // TODO: Sort by both mood date and date created
        
        moodsCollection
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                
                guard error == nil else {
                    print("[getUserData()]", error!)
                    return
                }
                
                for doc in snapshot!.documents {
                    
                    var mood = Mood()
                    mood.id = doc["id"] as? String ?? ""
                    mood.text = doc["text"] as? String ?? ""
                    mood.userId = doc["userId"] as? String ?? ""
                    
                    let date = doc["date"] as? Timestamp ?? nil
                    mood.date = date?.dateValue()
                    
                    currentUserMoods.append(mood)
                }
                
                completion(currentUserMoods)
        }
        
    }
}
