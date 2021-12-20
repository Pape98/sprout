//
//  AddEntrySheet.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct MoodViewAddEntrySheet: View {
    
    @EnvironmentObject var userModel: UserModel
    
    @State var date = Date()
    @State var selectedMood = ""
    
    @Binding var showAddEntrySheet: Bool
    
    var moodTypes = Constants.moodTypes
    var twoColumnGrid: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack {
            Text("How are you?")
                .font(.title)
            Spacer(minLength: 25)
            
            DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                .labelsHidden()
            
            Spacer(minLength: 50)
            
            ScrollView {
                LazyVGrid(columns: twoColumnGrid, spacing: 30) {
                    ForEach(moodTypes.map{String($0.key)} , id: \.self) { mood in
                        MoodViewCard(text: mood, color: moodTypes[mood]!, selectedMood: $selectedMood)
                            .onTapGesture {
                                selectedMood = mood
                            }
                    }
                }
                .padding()
            }
            
            CustomButton(title: "Save") {
                userModel.addMoodEntry(moodType: selectedMood, date: date)
                showAddEntrySheet = false
            }
            .padding()
            
            CustomButton(title: "Cancel") {
                showAddEntrySheet = false
            }
            .padding()
        }
        .padding()
    }
}

struct AddEntrySheet_Previews: PreviewProvider {
    
    @State static var showAddEntrySheet: Bool = false
    
    static var previews: some View {
        MoodViewAddEntrySheet(showAddEntrySheet: $showAddEntrySheet)
    }
}
