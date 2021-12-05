//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var healthModel = HealthModel()
    
    let steps = [Step(56, "Wednesday the 23rd"), Step(56, "Wednesday the 23rd") ]
    
    var body: some View {
        NavigationView {
            List(healthModel.dailySteps){ step in
                VStack(alignment: .leading, spacing: 15){
                    Text("Date: \(step.date)")
                    Text("Count: \(step.count)")
                }
            }
        }
        .navigationTitle("My Daily Steps")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
