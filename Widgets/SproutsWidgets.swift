//
//  SproutsWidgets.swift
//  PersonalStatusWidgetExtension
//
//  Created by Pape Sow Traoré on 30/10/2022.
//

import SwiftUI
import WidgetKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions

@main
struct SproutsWidgets {

    init(){
        addKeyChainAccessGroup()
        FirebaseApp.configure()
   
        if Platform.isSimulator {
            // Local firestore
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
            
            // Cloud Functions
            Functions.functions().useEmulator(withHost: "http://localhost", port:5001)
        }
    }
    
    func addKeyChainAccessGroup(){
        do {
            try Auth.auth().useUserAccessGroup("group.empower.lab.community-garden")
        } catch let error as NSError {
            print("Widget Error changing user access group: %@", (error as NSError).userInfo)
        }
    }
    
    static func main() {
        PersonalStatusWidget.main()
    }
    
}
