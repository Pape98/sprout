//
//  LoginView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authenticationModel: AuthenticationModel
    @State var email = ""
    @State var firstName = ""
    @State var lastName = ""
    
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
            
            // Form
            Group {
                
                // Button
                Button {
                    authenticationModel.signIn()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(height:40)
                            .cornerRadius(10)
                        
                        Text("Sign Up/ Login")
                            .foregroundColor(.white)
                    }
                }
                
                if let errorMessage = authenticationModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
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
            .environmentObject(AuthenticationModel())
    }
}
