//
//  AuthenticationViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    
    // MARK: - Properties
    
    // Login status of current usrer
    @Published var isLoggedIn = false
    @Published var userOnboarded = false
    
    // Error message to be displayed to user
    @Published var errorMessage: String?
    
    static var shared = AuthenticationViewModel()
    
    // Google Sign In configuration
    var configuration: GIDConfiguration?
    
    // Repository Instance
    var userRepository: UserRepository = UserRepository.shared
    
    let nc = NotificationCenter.default
    
    // MARK: - Methods
    
    init() {
        // Create Google Sign In configuration object.
        configuration = GIDConfiguration.init(clientID: Constants.clientID)
        checkLogin()
        setLoggedInUserProfile()
    }
    
    func checkLogin() {
        // Check if there's a current user to determine logged in status
        isLoggedIn = Auth.auth().currentUser != nil ? true : false
        
        if isLoggedIn {
            updateNewUserStatus()
        }
        
    }
    
    func updateNewUserStatus(){
        let userID = getUserID()!
        userRepository.fetchLoggedInUser(userID: userID) { user in
            self.userOnboarded = user.hasBeenOnboarded
        }
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
    
    // Set user information from Google
    func setLoggedInUserProfile(){
        checkLogin()
        
        if isLoggedIn {
            let firebaseUser = Auth.auth().currentUser
            userRepository.fetchLoggedInUser(userID: firebaseUser!.uid) { result in
                UserService.user = result
                NotificationSender.send(type: NotificationType.UserLoggedIn.rawValue)
            }
            // Check login status again to update UI
            DispatchQueue.main.async {
                self.checkLogin()
            }
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
                      // let userEmail = user?.profile?.email,
                      let idToken = authenticaton.idToken
                else { return }
                
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
                    
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    
                    // Check user if already exists in database
                    self.userRepository.doesUserExist(userID: userID){ result in
                        
                        // If user does not exist, create a new account
                        if result == false {
                            
                            let user = user!
                            
                            let newUser = User(id: userID,
                                               name: user.profile!.name,
                                               email: user.profile!.email
                            )
                            
                            self.userRepository.createNewUser(newUser)
                        }
                        
                        self.setLoggedInUserProfile()
                    }
                }
            }
        }
    }
}
