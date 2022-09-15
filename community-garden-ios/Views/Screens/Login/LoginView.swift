//
//  LoginView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authenticationModel: AuthenticationViewModel
    @Binding var yOffset: Int
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("intro-bg")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Image("sprout-logo")
                        .resizable()
                        .scaledToFit()
                    
                    
                    Text("Track Together")
                        .font(.title)
                        .foregroundColor(.pine)
                        .offset(y:-35)
                    
                    if (authenticationModel.isLoggedIn == false) {
                        // Sign-In Button
                        AuthButton()
                        
                    }
                    
                    // Error Message
                    if let errorMessage = authenticationModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .frame(width: geometry.size.width * 0.8)
                .offset(y: geometry.size.height * -0.2)
            }
        }
    }
}

struct AuthButton: View {
    
    @EnvironmentObject var authenticationModel: AuthenticationViewModel
    
    var body: some View {
        Button {
            authenticationModel.signIn()
        } label: {
            HStack {
                Text("Sign in with Google")
                    .font(.title2)
                    .foregroundColor(Color.white)
                Image("google-logo")
            }
        }
        .padding(15)
        .background(Color.greenVogue)
        .cornerRadius(10)
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var yOffset = 0
    
    static var previews: some View {
        
        LoginView(yOffset: $yOffset)
            .environmentObject(AuthenticationViewModel())
    }
}
