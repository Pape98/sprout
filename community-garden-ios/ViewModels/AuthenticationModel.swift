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
    
    // Login status of current usrer
    @Published var isLoggedIn = false
    
    // Error message to be displayed to user
    @Published var errorMessage: String?
    
    // Current user
    @Published var loggedInUser: User?
    
    // Google Sign In configuration
    var configuration: GIDConfiguration?
    
    // MARK: - Methods

    init () {
        
        // Create Google Sign In configuration object.
        configuration = GIDConfiguration.init(clientID: Constants.clientID)
        checkLogin()
    }
    
    func checkLogin() {
        
        // Check if there's a current user to determine logged in status
        isLoggedIn = Auth.auth().currentUser != nil ? true : false
        
        // Check if user meta data has been fetched. If the user was already logged in from a previous session, we need to get their data in a separate call
        if UserService.shared.loggedInUser.name == "" {
            setUserProfile()
        }
    }
    
    func setUserProfile() {
        
        guard let firebaseUser = Auth.auth().currentUser else {
            return
        }
        
        let user = UserService.shared.loggedInUser
        
        if (isLoggedIn) {
            user.id = firebaseUser.uid
            
            if let displayName = firebaseUser.displayName,
               let email = firebaseUser.email
            {
                user.email = email
                user.name = displayName
            }
        }
        
        loggedInUser = user
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
        
        self.errorMessage = ""
        
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
                      let userEmail = user?.profile?.email,
                      let idToken = authenticaton.idToken
                else { return }
                
                // Check if user is using school email
                if userEmail.contains("dartmouth.edu") == false {
                    // Update UI from main thread
                    DispatchQueue.main.async {
                        self.errorMessage = "You must use your dartmouth email."
                    }
                    return
                }
                
                // Create a Firebase auth credential from the Google Auth Token
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authenticaton.accessToken)
                
                // Complete the Firebase login process with the auth credential created in the previous step
                Auth.auth().signIn(with: credential) { result , error in
                    
                    guard error == nil else {
                        // Update UI from main thread
                        DispatchQueue.main.async {
                            self.errorMessage = error!.localizedDescription
                        }
                        return
                    }
                    
                    // Login is succcessful. Redirect user to home screen
                    self.checkLogin()
                   
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    
                    // Check user if already exists in database
                    if DatabaseService.shared.doesUserExist(userID: userID) == false {
                            // Update UI from main thread
                            DispatchQueue.main.async {
                                self.setUserProfile()
                            }
                        
                        guard let loggedInUser = self.loggedInUser else { return }
                        // If not existing already, add new user to database
                        DatabaseService.shared.createNewUser(loggedInUser)
                    }
                }
            }
        }
    }
}
