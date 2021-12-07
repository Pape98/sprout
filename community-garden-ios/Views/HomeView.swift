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
    
    let steps = [Step(56, "Monday the 23rd"), Step(78, "Wednesday the 23rd") ]
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Button("Sign Out", action: authenticationModel.signOut)

                List(healthModel.dailySteps){ step in
                    Text("Date: \(step.date)")
                        .font(.headline)
                        Text("Count: \(step.count)")
                } .navigationBarTitle("Your Steps")
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

