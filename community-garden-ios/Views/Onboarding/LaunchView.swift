//
//  LaunchView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var authModel: AuthenticationViewModel
    
    var body: some View {
        
        if authModel.isLoggedIn == false {
            // Show login view
            LoginView()
                .onAppear {
                    // Check if user is logged in or out
                    authModel.checkLogin()
                }
            
        } else {
            // Show logged in view (home view)
            ContentView()
        }
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(AuthenticationViewModel())
    }
}
