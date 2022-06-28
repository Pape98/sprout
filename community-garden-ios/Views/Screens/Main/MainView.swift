//
//  MainView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 28/06/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Dashboard()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                        .padding()
                }
            
            FriendsList()
                .tabItem {
                    Label("Friends", systemImage: "person.3")
                        .padding()
                }
            
        }
        .background(Color.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserViewModel())
    }
}
