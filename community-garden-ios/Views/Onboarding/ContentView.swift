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
    
    
    var body: some View {
        
        TabView {
            Dashboard()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
            
            StepView()
                .tabItem {
                    Image(systemName: "leaf")
                    Text("My Garden")
                }
            
            StepView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Friends")
                }
            
            
            //            CustomButton(title: "Sign Out",
            //                         backgroundColor: Color.red,
            //                         fontColor: Color.white,
            //                         action: authViewModel.signOut)
            //            .frame(width:200)
            //            .tabItem {
            //                Image(systemName: "arrowshape.turn.up.right")
            //                Text("Sign Out")
            //            }
        }.environmentObject(userViewModel)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
    }
}
