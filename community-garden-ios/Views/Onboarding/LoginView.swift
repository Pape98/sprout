//
//  LoginView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authenticationModel: AuthenticationViewModel
    @State var email = ""
    @State var firstName = ""
    @State var lastName = ""
    
    var body: some View {
        
        ZStack {
            
            // Sun
            
            ZStack(alignment: .bottomTrailing) {
                Image("flower-pot")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            
            // Leaves background
            
            ZStack {
                Image("leaves")
                    .resizable()
                    .scaleEffect()
                    .frame(maxHeight: 500)
           
            }
            
            // Text and Button
            
            VStack {
                Text("Log-in/ Sign-Up")
                    .font(.title)
                    .bold()
                    .padding()
                
                // Login Button
                
                CustomButton(title: "Sign In with Google",
                             backgroundColor: Color(red: 0.8667, green: 0.7176, blue: 0.4431),
                             fontColor: Color.black
                ) {
                    authenticationModel.signIn()
                }
                .padding()
                .frame(maxWidth: 250)
                
                
                // Error Message
                
                if let errorMessage = authenticationModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                

            }
            
            // Flower Pot
            ZStack(alignment: .bottomTrailing) {
                Image("sun")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
       
            
        }.ignoresSafeArea()

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}
