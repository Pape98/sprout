//
//  UserRepo.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/4/22.
//

import Foundation
import FirebaseFirestore
import GoogleSignIn

class UserRepository {
    
    // MARK: - Properties
    let collections = Collections.shared
    let usersCollection: CollectionReference?
    static let shared = UserRepository() // Single repo instance shared
    var doesUserExsist = false
    
    // MARK: - Methods
    
    init() {
        // Get collection references
        usersCollection = collections.db.collection("users")
    }
    
    func createNewUser(_ user: User) {
        guard let usersCollection = usersCollection else {
            return
        }
        
        do {
            try usersCollection.document(user.name).setData(from: user)
        } catch let err {
            print("[createNewUser()]","Error writing document: \(err)")
        }
    }
    
    func doesUserExist(userID: String, completion: @escaping () -> Void) {
        guard let usersCollection = usersCollection else {
            return
        }
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
        guard let usersCollection = usersCollection else {
            return
        }
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
    
    
    func updateUser(userID: String, updates:[String: Any], completion: @escaping() -> Void){
        guard let usersCollection = usersCollection else {
            return
        }
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
    
    // Fetch all users except current user
    func fetchAllUsers(userID: String, completion: @escaping (_ users: [User]) -> Void){
        guard let usersCollection = usersCollection else {
            return
        }
        let query = usersCollection.whereField("id", isNotEqualTo: userID)
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var users:[User] = []
                for document in querySnapshot!.documents {
                    
                    do {
                        let decodedUser: User = try document.data(as: User.self)
                        users.append(decodedUser)
                    } catch {
                        print("[fetchLoggedInUser()]", error)
                    }
                }
                completion(users)
            }
        }
    }
}
