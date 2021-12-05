//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var healthModel = HealthModel()
    
    var body: some View {
        Text("Community Garden Application!")
            .padding()
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
