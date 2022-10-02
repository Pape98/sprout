//
//  MessageOptions.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/07/2022.
//

import SwiftUI
import AVFoundation

struct MessageOptions: View {
    
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var selectedMessage: MessageOption = MessageOption(text: "Proud of you!", color: "cosmos")
    @State private var isMessagePrivate = true
    @State private var messageText = ""
    @State private var showErrorAlert = false
    
    var user: User
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .top) {
                    
                    MainBackground(image: "sky-cloud-bg",edges: [.bottom])
                    
                    VStack {
                        
                        VStack {
                            if let settings = user.settings {
                                CircledTree(option: "\(settings.treeColor)-\(addDash(settings.tree))",
                                            background: .haze,
                                            size: 140)
                            }
                            
                            Text(user.name)
                                .bodyStyle()
                                .foregroundColor(appViewModel.fontColor)
                        }
                        .padding(.top)
                        
                        // Selected Messsage
                        Text(messageText)
                            .frame(alignment: .center)
                            .padding()
                            .multilineTextAlignment(.center)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.haze)
                                    .opacity(0.8)
                                    .frame(width: geometry.size.width * 0.9)
                            }
                            .padding()
                        
                        // Form
                        Form {
                            Section("Content") {
                                
                                TextField("Enter message here", text: $messageText)
                                
                                Toggle("Make Anonymous", isOn: $isMessagePrivate)
                            }
                            
                        }
                        .offset(y: -20)
                        .modifier(ListBackgroundModifier())
                    }
                }
                .alert("Message cannot be empty 😊", isPresented: $showErrorAlert){
                    Button("OK", role: .cancel){}
                }
                .navigationTitle("Send Message")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("sending")
                        } label: {
                            Image(systemName: "paperplane")
                                .foregroundColor(.seaGreen)
                                .onTapGesture {
                                    
                                    if messageText.isEmpty {
                                        showErrorAlert = true
                                        return
                                    }
                                    
                                    AudioPlayer.shared.playSystemSound(soundID: 1004)
                                    
                                    messagesViewModel.sendMessage(receiver: user,
                                                                  text: messageText,
                                                                  isPrivate: isMessagePrivate)
                                    
                                    messagesViewModel.showMessageOptionsSheet = false
                                }
                        }
                    }
                }
                
            }
        }
    }
}



struct MessageOptions_Previews: PreviewProvider {
    static let settings = UserSettings(tree: "sad holly", treeColor: "grenadier")
    static let user = User(id: UUID().uuidString, name: "Pape Sow Traore", settings: settings)
    static var previews: some View {
        MessageOptions(user: user)
            .environmentObject(MessagesViewModel())
            .environmentObject(AppViewModel())
    }
}
