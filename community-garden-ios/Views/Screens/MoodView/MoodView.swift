//
//  MoodView.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/19/21.
//

import SwiftUI

struct MoodView: View {
    
    @State var showAddEntrySheet = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Button {
                showAddEntrySheet.toggle()
            } label: {
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .frame(width: 200, height: 45)
                        .padding(40)
                        .shadow(radius: 5)
                    
                    
                    Text("Add New Entry")
                        .bold()
                        .foregroundColor(Color.white)
                }
            }
            .sheet(isPresented: $showAddEntrySheet, content: {AddEntrySheetView()})
            
        }
        .navigationTitle("Your Mood")
    }
}


struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
