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
import SwiftDate

class FirebaseHelper {
    let db: Firestore
    
    @Published var isLoggedIn = false
    
    init(){
        db = Firestore.firestore()
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
            return -1
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
        guard let _ = Auth.auth().currentUser else {
            print("User is not logged in")
            return -1
        }
        
        let groupNumber = await getUserGroup()
        
        // get date
        let region = Region(calendar: Calendars.gregorian, zone: Zones.americaNewYork)
        let date = DateInRegion(Date(), region: region).toFormat("MM-dd-yyyy")
                
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
