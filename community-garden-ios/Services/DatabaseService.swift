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
        case users, steps
    }
    
    // Single database instance shared
    static let shared = DatabaseService()
    
    // MARK: - Properties
    
    let db: Firestore
    let usersCollection: CollectionReference
    var doesUserExsist = false
    
    // MARK: - Methods
    init() {
        
        // Get a reference to database
        db = Firestore.firestore()
        
        // Get a reference
        usersCollection = db.collection(Collection.users.rawValue)
    }
    
    func createNewUser(_ user: User) {
        
        let newUser: [String: Any] = ["id": user.id,
                                      "name": user.name,
                                      "email": user.email]
        
        usersCollection.document(user.id).setData(newUser){ err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
    }
    
    func doesUserExist(userID: String, completion: @escaping () -> Void) {
        // Get document reference
        let userRef = usersCollection.document(userID)
        
        // Check if user exists in database
        userRef.getDocument { document, error in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            if let condition = document?.exists {
                self.doesUserExsist = condition
            }
            
            completion()
        }
    }
    
    func updateUserTrackedData(userID: String, collection: Collection, update: [String: Any]) {
        
        // Get document reference
        let userRef = usersCollection.document(userID)
        guard let date = update["date"] as? String else { return }
        
        // Perform update operation
        userRef
            .collection(Collection.steps.rawValue)
            .document(date)
            .setData(update)
    }
    
    func getUserData(userID: String) {
        usersCollection.document(userID).getDocument { document, error in
            guard let userDoc = document else { return }
        }
    }
    
}
