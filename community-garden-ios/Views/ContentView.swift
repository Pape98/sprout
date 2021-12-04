//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import SwiftUI

struct ContentView: View {
    
    private var healthStore: HealthStore
    
    init() {
        healthStore = HealthStore()
    }
    
    var body: some View {
        Text("Community Garden Application!")
            .padding()
        
            .onAppear{
                healthStore.requestAuthorization { success in
                    
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
