//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var userModel: UserViewModel = UserViewModel()
    @EnvironmentObject var authModel: AuthenticationViewModel
    
    var body: some View {
        TabView {
            
            MoodView()
                .tabItem {
                    Image(systemName: "hand.thumbsup")
                    Text("Mood")
                }
            
            StepView()
                .tabItem {
                    Image(systemName: "bolt.horizontal")
                    Text("Steps")
                }
            
            CustomButton(title: "Sign Out", action: authModel.signOut)
                .tabItem {
                    Image(systemName: "arrowshape.turn.up.right")
                    Text("Sign Out")
                }
            
            
            
        }
        .environmentObject(userModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
    }
}
