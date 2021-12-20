//
//  AddEntrySheet.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct AddEntrySheetView: View {
    
    @State private var moodDate = Date()
    @State var selectedMood = ""
    
    private var moodTypes = Constants.moodTypes
    private var twoColumnGrid: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack {
            
            //            DatePicker("Date", selection: $moodDate, in: ...Date(), displayedComponents: .date)
            ScrollView {
                LazyVGrid(columns: twoColumnGrid, spacing: 30) {
                    ForEach(moodTypes.map{String($0.key)} , id: \.self) { mood in
                        MoodCard(text: mood, color: moodTypes[mood]!, selectedMood: $selectedMood)
                            .onTapGesture {
                                selectedMood = mood
                            }
                    }
                }
            }
        }
    }
}

struct MoodCard: View {
    
    var text = "Happy"
    var color = Color.white
    @Binding var selectedMood: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .frame(width: 135, height: 135)
            .foregroundColor(selectedMood != text ? color : Color.white)
            .background(selectedMood == text ? color : Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 16).stroke(color, lineWidth: 2)
            )
            .shadow(radius: 1)
    }
}


struct AddEntrySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddEntrySheetView()
    }
}
