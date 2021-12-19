//
//  ContentView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/3/21.
//

import SwiftUI

struct HomeView: View {
    
    
    var body: some View {
        Text("Home View")
    }
    
    struct Home_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
                .environmentObject(AuthenticationModel())
        }
    }
    
}
