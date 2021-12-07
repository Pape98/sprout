//
//  Database.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/7/21.
//

import Foundation
import Firebase

class DatabaseService {
    
    // Single database instance shared
    static let shared = DatabaseService()
    
    // MARK: - Properties
    let USERS_COLLECTION = "users"
    let db: Firestore?
    
    
    // MARK: - Methods
    init() {
        db = Firestore.firestore()
    }
    
    func createNewUser(_ user: User) {
        
        let newUser: [String: Any] = ["id": user.id, "name": user.name,"email": user.email]
        
        
        db?.collection(USERS_COLLECTION).document(user.id).setData(newUser){ err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
    }
    
    func doesUserExist(userID: String) -> Bool {
        
        var doesExsist = false
        
        if let docRef = db?.collection(USERS_COLLECTION).document(userID){
            docRef.getDocument { document, error in
                
                guard error == nil else {
                    print(error!)
                    return
                }
                
                if let condition = document {
                    doesExsist = condition.exists
                }
            }
        }
        return doesExsist
    }
    
}
