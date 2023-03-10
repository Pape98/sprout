//
//  UserRepo.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/4/22.
//

import Foundation
import FirebaseFirestore
import GoogleSignIn
import FirebaseAuth

class UserRepository {
    
    // MARK: - Properties
    let collections = Collections.shared
    let usersCollection: CollectionReference?
    static let shared = UserRepository() // Single repo instance shared
    
    // MARK: - Methods
    
    init() {
        // Get collection references
        usersCollection = collections.db.collection(CollectionName.users.rawValue)
    }
    
    func createNewUser(_ user: User) {
        guard let usersCollection = usersCollection else {
            return
        }
        
        do {
            try usersCollection.document(user.id).setData(from: user)
        } catch let err {
            Debug.log.error("[createNewUser()]","Error writing document: \(err)")
        }
    }
    
    func doesUserExist(userID: String, completion: @escaping (_ userExists: Bool?) -> Void) {
        guard let usersCollection = usersCollection else {
            return
        }
        // Get document reference
        let userRef = usersCollection.document(userID)
        
        // Check if user exists in database
        userRef.getDocument { document, error in
            
            guard error == nil else {
                Debug.log.error("[doesUserExist()]: \(error)!")
                return
            }
            completion(document?.exists)
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
                Debug.log.error("[fetchLoggedInUser()]: \(error!.localizedDescription)!")
                return
            }
            
            do {
                let decodedUser: User = try document!.data(as: User.self)
                UserService.shared.user = decodedUser
                completion(decodedUser)
            } catch {
                Debug.log.error("[fetchLoggedInUser() decoding]: \(error.localizedDescription)")
                
                // FIXME: Remove later in production
                AuthenticationViewModel.shared.signOut()
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
                Debug.log.error("Error updating document: \(err)")
            } else {
                completion()
            }
            
        }
        
    }
    
    // Fetch all users except current user
    func fetchAllUsers(query: Query, completion: @escaping (_ users: [User]) -> Void){
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                Debug.log.error("Error getting documents: \(error)")
            } else {
                var users:[User] = []
                for document in querySnapshot!.documents {
                    
                    do {
                        let decodedUser: User = try document.data(as: User.self)
                        users.append(decodedUser)
                    } catch {
                        Debug.log.error("[fetchAllUsers()]: \(error)")
                        
                    }
                }
                completion(users)
            }
        }
    }
}
