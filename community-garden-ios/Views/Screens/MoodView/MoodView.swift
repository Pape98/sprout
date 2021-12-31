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
    
    let moods: [Mood] = [Mood(text:"meh", date:"12-22-1998"), Mood(text:"terrible", date:"11-14-1990") ]
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0){
                ScrollView {
                    ForEach(userModel.currentUserData.moods) { mood in
                            HStack {
                                Text(mood.date)
                                    .padding()
                                Spacer()
                                Text(mood.text)
                                    .padding()
                            }
                            .frame(height:75)
                            .font(.title3)
                            .background(Constants.moodTypes[mood.text])
                            .foregroundColor(Color.white)
                        }
                }
                Spacer()
                
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
            .environmentObject(UserModel())
    }
}
