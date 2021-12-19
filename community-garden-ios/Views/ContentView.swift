//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            StepView()
                .tabItem {
                    Image(systemName: "bolt.horizontal")
                    Text("Steps")
                }
            MoodView()
                .tabItem {
                    Image(systemName: "hand.thumbsup")
                    Text("Mood")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
