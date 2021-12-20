//
//  MoodView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct MoodView: View {
    
    @EnvironmentObject var userModel: UserModel
    @State var showAddEntrySheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Mood Visualization")
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Your Mood")
                        .font(.title)
                        .bold()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        showAddEntrySheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                    }
                    .sheet(isPresented: $showAddEntrySheet, content: {MoodViewAddEntrySheet(showAddEntrySheet: $showAddEntrySheet)})
                }
            }
        }
    }
    
}

struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
