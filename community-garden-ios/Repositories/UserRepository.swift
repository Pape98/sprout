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
    let usersCollection: CollectionReference
    static let shared = UserRepository() // Single repo instance shared
    var doesUserExsist = false
    
    // MARK: - Methods
    
    init() {
        // Get collection references
        usersCollection = Collections.shared.getCollectionReference("users")
    }
    
    func createNewUser(_ user: User) {
        
        let newUser: [String: Any] = ["id": user.id,
                                      "name": user.name,
                                      "email": user.email,
                                      "oldStepCount": 0,
                                      "numDroplets": 0]
        
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
    
    func fetchLoggedInUser(userID: String, completion: @escaping (_ user: User) -> Void){
        // Get document reference
        let userRef = usersCollection.document(userID)
        
        // Check if user exists in database
        userRef.getDocument { document, error in
            
            guard error == nil else {
                print("[fetchLoggedInUser()]", error!)
                return
            }
            
            do {
                let decodedUser: User = try document!.data(as: User.self)
                completion(decodedUser)
            } catch {
                print("[fetchLoggedInUser()]", error)
            }
            
            
        }
    }
    
    func updateUser(userID: String, updates:[String: Any],completion: @escaping() -> Void){
        
        // Get document reference
        let userRef = usersCollection.document(userID)
        
        userRef.updateData(updates) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                completion()
            }
            
        }
        
    }
}
