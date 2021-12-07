//
//  UserModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import Foundation
import FirebaseAuth

class UserModel: ObservableObject {
    
    // Authenticatiom
    @Published var isLoggedIn = false
    
    func checkLogin(){
        isLoggedIn = Auth.auth().currentUser != nil ? true : false
    }
}
