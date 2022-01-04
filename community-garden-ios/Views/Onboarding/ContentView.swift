//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var userViewModel: UserViewModel = UserViewModel()
    @StateObject var moodViewModel: MoodViewModel = MoodViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
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
            
            CustomButton(title: "Sign Out", action: authViewModel.signOut)
                .frame(width:200)
                .tabItem {
                    Image(systemName: "arrowshape.turn.up.right")
                    Text("Sign Out")
                }
            
            
            
        }
        .environmentObject(userViewModel)
        .environmentObject(moodViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
    }
}
