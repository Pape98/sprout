//
//  LoginView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userModel: UserModel
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var firstName = ""
    @State var lastName = ""
    
    var buttonText: String {
        if loginMode == Constants.LoginMode.login {
            return "Login"
        } else {
            return "Sign Up"
        }
    }
    
    var body: some View {
        VStack (spacing: 10) {
            Spacer()
            
            // Logo
            Image(systemName: "leaf")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 100)
            
            // Title
            Text("Community Garden")
                .font(.title)
                .padding()

            
            // Picker
            Picker(selection: $loginMode, label: Text("Hey")){
                Text("Login")
                    .tag(Constants.LoginMode.login)
                Text("Sign Up")
                    .tag(Constants.LoginMode.createAccount)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Form
            TextField("Email", text: $email)
            
            if loginMode == Constants.LoginMode.createAccount {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
            }
            
            // Button
            Button {
                
                if loginMode == Constants.LoginMode.login {
                    // Login in user
                    
                } else {
                    // Create a new account
                }
                
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(height:40)
                        .cornerRadius(10)
                    
                    Text(buttonText)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserModel())
    }
}
