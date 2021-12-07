//
//  UserModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import SwiftUI

class AuthenticationModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    var configuration: GIDConfiguration?
    
    // MARK: - Methods

    init () {
        
        // Create Google Sign In configuration object.
        configuration = GIDConfiguration.init(clientID: Constants.clientID)
    }
    
    func checkLogin() {
        isLoggedIn = Auth.auth().currentUser != nil ? true : false
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.checkLogin()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func signIn() {
        if let configuration = self.configuration {
        
            let rootViewController = UIApplication.shared.windows.first!.rootViewController
            
            guard rootViewController != nil else {
                return
            }
            
            // Start the Google sign in flow!
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController!) { user, error in
                
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.errorMessage = error!.localizedDescription
                    }
                    return
                }
                
                guard let authenticaton = user?.authentication,
                      let idToken = authenticaton.idToken
                else { return }
                
                // Create a Firebase auth credential from the Google Auth Token
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authenticaton.accessToken)
                
                
                // Complete the Firebase login process with the auth credential created in the previous step
                
                Auth.auth().signIn(with: credential) { result , error in
                    
                    guard error == nil else {
                        DispatchQueue.main.async {
                            self.errorMessage = error!.localizedDescription
                        }
                        return
                    }
                    
                    // User is logged in
                    self.checkLogin()
                }
            }
        }
    }
}
