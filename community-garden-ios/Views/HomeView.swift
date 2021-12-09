//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var userModel = UserModel()
    @EnvironmentObject var authenticationModel: AuthenticationModel
        
//    let steps = [Step(count:56, date:"Monday the 23rd"), Step(count:78, date:"Wednesday the 23rd") ]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
//                    Text("Hi \(authenticationModel.loggedInUser?.name ?? "Pape Sow Traore")")
                    Spacer()
                    Button("Sign Out", action: authenticationModel.signOut)
                }
                .padding(.horizontal)
                
                List(userModel.currentUser.steps){ step in
                    Group {
                        Text("Date: \(step.date)")
                            .font(.headline)
                        Text("Count: \(step.count)")
                    }
                }
            } .navigationBarTitle("Your Steps")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthenticationModel())
    }
}

