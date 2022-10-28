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
    
    @State var text = ""
    @State var isPrivate = true
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    MainBackground()
                    VStack {
                        
                        Text("Enter text below")
                            .bodyStyle(foregroundColor: appViewModel.fontColor)
                        
                        
                        TextEditor(text: $text)
                            .frame(width: geo.size.width * 0.82, height: geo.size.height * 0.25)
                            .cornerRadius(10)
                        
                        Form {
                            Section("Parameters"){
                                Toggle("Anonymous", isOn: $isPrivate)
                            }
                        }
                        .modifier(ListBackgroundModifier())
                        
                        ActionButton(title: "Send", backgroundColor: .appleGreen, fontColor: .white) {
                            messagesViewModel.sendCommunityMessage(text: text, isPrivate: isPrivate)
                            messagesViewModel.showSendCommunityMessageSheet = false
                            AudioPlayer.shared.playSystemSound(soundID: 1004)
                        }
                        .frame(width: 150)
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
                            .foregroundColor(appViewModel.fontColor)
                            .onTapGesture {
                                messagesViewModel.showSendCommunityMessageSheet = false
                            }
                    }
                }
                .onAppear {
                    messagesViewModel.getCommunityFeed()
                }
            }
        }
    }
}

struct SendCommunityMessage_Previews: PreviewProvider {
    static var previews: some View {
        SendCommunityMessage()
            .environmentObject(MessagesViewModel())
            .environmentObject(AppViewModel())
    }
}
