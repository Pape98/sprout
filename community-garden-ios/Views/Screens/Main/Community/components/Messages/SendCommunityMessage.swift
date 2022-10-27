//
//  CommunityFeed.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 10/26/22.
//

import SwiftUI

struct SendCommunityMessage: View {
    
    @EnvironmentObject var messagesViewModel : MessagesViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State var text = "sdsdsdsddwdwdw"
    @State var isAnonymous = false
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    MainBackground()
                    VStack {
                        
                        Text("Enter text below")
                            .bodyStyle(foregroundColor: appViewModel.fontColor)
                        
                        TextEditor(text: $text)
                            .frame(height: geo.size.height * 0.30)
                            .cornerRadius(10)
                        
                        Toggle("Show welcome message", isOn: $isAnonymous)
                        
                        ActionButton(title: "Send", backgroundColor: .appleGreen, fontColor: .white) {
                            messagesViewModel.showSendCommunityMessageSheet = false
                        }
                        .frame(width: 200)
                        .padding()
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Community Message")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "multiply")
                            .foregroundColor(.seaGreen)
                            .onTapGesture {
                                messagesViewModel.showSendCommunityMessageSheet = false
                            }
                    }
                }
            }
        }
    }
}

struct SendCommunityMessage_Previews: PreviewProvider {
    static var previews: some View {
        SendCommunityMessage()
            .environmentObject(MessagesViewModel())
    }
}
