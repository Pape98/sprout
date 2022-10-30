//
//  FirebaseHelper.swift
//  PersonalStatusWidgetExtension
//
//  Created by Pape Sow Traoré on 30/10/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class FirebaseHelper {
    static let shared = FirebaseHelper()
    let db = Firestore.firestore()
    
    @Published var isLoggedIn = false
    
    init(){
        isUserLoggedIn()
    }
    
    func isUserLoggedIn(){
        DispatchQueue.main.async {
            self.isLoggedIn = Auth.auth().currentUser != nil
        }
    }
    
    func getUserGroup() async -> Int {
        guard let user = Auth.auth().currentUser else {
            print("User is not logged in")
            return 0
        }
        let collection = db.collection("users")
        let userRef = collection.document(user.uid)
        
        do {
            let document = try await userRef.getDocument().data()
            return document!["group"]! as! Int
            
        } catch {
            print(error)
            return -1
        }
    }
    
    func getGroupProgress() async -> Int {
        let groupNumber = await getUserGroup()
        let date = Date().toFormat("MM-dd-yyyy")
        let docName = "\(groupNumber)-\(date)"
        let docRef = db.collection("goals").document(docName)
        
        do {
            let document = try await docRef.getDocument().data()
            let numGoalsAchieved = document!["numberOfGoalsAchieved"] as! Int
            let completionPercentage = Int(100 * (Double(numGoalsAchieved)/12.0))
            return completionPercentage
        } catch {
            print(error)
            return -1
        }
    }
}
