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
    @State var email = ""
    @State var firstName = ""
    @State var lastName = ""
    
    var body: some View {
        
        
        GeometryReader { geometry in
            ZStack {
                
                // Background Image
                Image("intro-bg")
                    .resizable()
                    .scaledToFill()
                
                // Content
                
                VStack {
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                    VStack(spacing: 50) {
                        
                        Group {
                            VStack {
                                Image("sprout-logo")
                                    .resizable()
                                    .scaledToFit()
                                
                                
                                Text("Track Together")
                                    .font(.title)
                                    .foregroundColor(.pine)
                            }
                            
                            if (authenticationModel.isLoggedIn == false) {
                                // Sign-In Button
                                
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
                                .padding(20)
                                .background(Color.greenVogue)
                                .cornerRadius(10)
                            }
                        }
                        .offset(y: CGFloat(yOffset))
                        .animation(.linear(duration: 2.0).delay(1.5), value: yOffset)
                    
                        
                        // Error Message
                        if let errorMessage = authenticationModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                    }
                    .frame(width: geometry.size.width * 0.8)
                    
                    Spacer()
                }
                
            }.ignoresSafeArea()
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var yOffset = 0
    
    static var previews: some View {
        
        LoginView(yOffset: $yOffset)
            .environmentObject(AuthenticationViewModel())
    }
}
