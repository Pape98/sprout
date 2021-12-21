//
//  MoodView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct MoodView: View {
    
    @EnvironmentObject var userModel: UserModel
    // @EnvironmentObject var authModel:AuthenticationModel
    
    @State var showAddEntrySheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Mood Visualization")
            }
            .navigationTitle("Your Mood")

        }
        .navigationViewStyle(StackNavigationViewStyle())
        .overlay(alignment: .bottomTrailing) {
            Button {
                showAddEntrySheet = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 50))
            }
            .padding(20)
            .sheet(isPresented: $showAddEntrySheet, content: {MoodViewAddEntrySheet(showAddEntrySheet: $showAddEntrySheet)})
        }
    }
    
}

struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
