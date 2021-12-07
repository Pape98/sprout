//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var healthModel = HealthModel()
    @EnvironmentObject var authenticationModel: AuthenticationModel
        
    let steps = [Step(count:56, date:"Monday the 23rd"), Step(count:78, date:"Wednesday the 23rd") ]
    
    var body: some View {
        NavigationView {
            
            VStack {
                Text("Hi \(authenticationModel.loggedInUser?.name ?? "")")
                List(healthModel.dailySteps){ step in
                    Text("Date: \(step.date)")
                        .font(.headline)
                    Text("Count: \(step.count)")
                } .navigationBarTitle("Your Steps")
                Button("Sign Out", action: authenticationModel.signOut)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

