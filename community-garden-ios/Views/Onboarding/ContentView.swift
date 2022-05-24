//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct ContentView: View {
    
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var userViewModel: UserViewModel = UserViewModel.shared
    @StateObject var friendsViewModel: FriendsViewModel = FriendsViewModel.shared
    
    
    var body: some View {
        
        TabView {
            NavigationView {
                Dashboard()
                    .navigationBarTitle(Text("Dashboard"))
                    .toolbar {
                        Button("Sign out"){
                            authViewModel.signOut()
                        }
                    }
            }
            .tabItem {
                Image(systemName: "house")
                Text("Dashboard")
            }
            
            NavigationView {
                MyGarden()
                    .navigationTitle("My Garden")
            }
            .tabItem {
                Image(systemName: "leaf")
                Text("My Garden")
            }
            
            NavigationView {
                FriendsList()
                    .navigationTitle("Your Friends")
            }
            .tabItem {
                Image(systemName: "person.3")
                Text("Friends")
            }
            
            
        }
        .environmentObject(userViewModel)
        .environmentObject(friendsViewModel)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
    }
}
