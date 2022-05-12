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
    @StateObject var healthStoreViewModel: HealthStoreViewModel = HealthStoreViewModel.shared
    
    
    var body: some View {
        TabView {
            
            StepView()
                .tabItem {
                    Image(systemName: "bolt.horizontal")
                    Text("Steps")
                }
            
            
            CustomButton(title: "Sign Out",
                         backgroundColor: Color.red,
                         fontColor: Color.white,
                         action: authViewModel.signOut)
            .frame(width:200)
            .tabItem {
                Image(systemName: "arrowshape.turn.up.right")
                Text("Sign Out")
            }
        }
        .environmentObject(userViewModel)
        .environmentObject(healthStoreViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
    }
}
