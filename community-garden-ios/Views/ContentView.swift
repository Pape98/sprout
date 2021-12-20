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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
