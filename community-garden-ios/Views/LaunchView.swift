//
//  LaunchView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/6/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        
        if userModel.isLoggedIn == false {
            // Show login view
            LoginView()
                .onAppear {
                    // Check if user is logged in or out
                    userModel.checkLogin()
                }

        } else {
            // Show home view
            //HomeView()
        }
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(UserModel())
    }
}
