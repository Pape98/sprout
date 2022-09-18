//
//  Messages.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 22/07/2022.
//

import SwiftUI

enum ViewMessageType {
    case received
    case sent
}

struct Messages: View {
    
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @State var selectedMessageType: ViewMessageType = .received
    @State private var isShowingSheet = false
    @State var date = ""
    
    var messages: [Message] {
        if selectedMessageType == .received {
            return messagesViewModel.receivedMessages
        } else {
            return messagesViewModel.sentMessages
        }
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                MainBackground()
                
                // Message type selection
                
                VStack {
                    
                    Picker("", selection: $selectedMessageType){
                        Text("Received").tag(ViewMessageType.received)
                        Text("Sent").tag(ViewMessageType.sent)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    ScrollView {
                        
                        VStack{
                            ForEach(messages){ message in
                                MessageCard(message: message, messageType: selectedMessageType)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                
            }
            .sheet(isPresented: $isShowingSheet, content: {
                //                MessageOptions(user: garden.user)
                
                Text("Pape")
            })
            .navigationBarTitle("Messages", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Refresh"){
                        messagesViewModel.getUserMessages()
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func formatDate(_ date: Date) -> String {
        return date.getFormattedDate(format: "MMM d, yyyy")
    }
    
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        Messages()
            .environmentObject(MessagesViewModel())
    }
}
