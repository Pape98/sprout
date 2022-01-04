//
//  UserRepo.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/4/22.
//

import Foundation
import FirebaseFirestore

class UserRepository {
    // MARK: - Properties
    
    let db: Firestore
    let usersCollection: CollectionReference
    static let shared = UserRepository() // Single repo instance shared
    var doesUserExsist = false
    
    init() {
        
        // Get a reference to database
        db = Firestore.firestore()
        
        // Get collection references
        usersCollection = db.collection(Constants.Collection.users.rawValue)
    }
    
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
}
