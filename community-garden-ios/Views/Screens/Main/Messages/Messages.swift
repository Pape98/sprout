//
//  Messages.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 22/07/2022.
//

import SwiftUI

struct Messages: View {
    
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    
    var body: some View {
        
        NavigationView {
            ZStack {
                MainBackground()
                
                // List of messages
                
                List(messagesViewModel.userMessages) { message in
                    VStack {
                        Text("From: \(message.senderName)")
                        Text("Text: \(message.text)")
                    }
                }
                
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        Messages()
            .environmentObject(MessagesViewModel())
    }
}
