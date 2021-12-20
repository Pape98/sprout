//
//  MoodViewCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct MoodViewCard: View {
    
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
                RoundedRectangle(cornerRadius: 16).stroke(color, lineWidth: selectedMood != text ? 2 : 0)
            )
            .shadow(radius: 1)
    }
}

struct MoodViewCard_Previews: PreviewProvider {
    @State static var selectedMood = ""
    
    static var previews: some View {
        MoodViewCard(text:"Happy", color: Color.green, selectedMood: $selectedMood)
    }
}
