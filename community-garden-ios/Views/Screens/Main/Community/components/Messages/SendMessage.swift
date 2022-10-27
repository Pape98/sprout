//
//  MessageOptions.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/07/2022.
//

import SwiftUI
import AVFoundation

struct SendSingleUserMessage: View {
    
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var communityViewModel: CommunityViewModel
    
    
    @State private var isMessagePrivate = true
    @State private var messageText = ""
    @State private var showErrorAlert = false
    
    @State var selectedUser: User? = nil
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .top) {
                    
                    MainBackground()
                    
                    VStack(spacing: 10) {
                        
                        Text("Scroll right and tap tree to select recipient")
                            .bodyStyle(foregroundColor: appViewModel.fontColor,size: 16)
                            .frame(width: geometry.size.width * 0.9, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 20) {
                                ForEach(Array(communityViewModel.members.values)){ member in
                                    UserCard(user: member)
                                        .onTapGesture {
                                            selectedUser = member
                                        }
                                }
                            }
                        }
                        .padding()
                        
                        // Selected Messsage
                        Text("Message preview")
                            .bodyStyle(foregroundColor: appViewModel.fontColor,size: 16)
                            .frame(width: geometry.size.width * 0.9, alignment: .leading)
                        
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
                        
                        Text("Content")
                            .bodyStyle(foregroundColor: appViewModel.fontColor,size: 16)
                            .frame(width: geometry.size.width * 0.9, alignment: .leading)
                        
                        Form {
                            
                            TextField("Enter message here", text: $messageText)
                            Toggle("Make Anonymous", isOn: $isMessagePrivate)
                            
                            
                        }
                        .offset(y: -20)
                        .modifier(ListBackgroundModifier())
                        
                        ActionButton(title: "Send", backgroundColor: .appleGreen, fontColor: .white) {
                            if messageText.isEmpty || selectedUser == nil {
                                showErrorAlert = true
                                return
                            }
                            
                            AudioPlayer.shared.playSystemSound(soundID: 1004)
                            
                            messagesViewModel.sendMessage(receiver: selectedUser!,
                                                          text: messageText,
                                                          isPrivate: isMessagePrivate)
                            
                            messagesViewModel.showSendSingleUserMessageSheet = false
                        }
                        .padding()
                        .frame(width: 200)
                        
                    }
                }
                .alert(isPresented: $showErrorAlert){
                    Alert(
                        title: Text("Error"),
                        message: Text("Recipient must be selected and message cannot be empty 😊"),
                        dismissButton: .default(Text("Got it!"))
                    )
                }
                .navigationTitle("Send Message")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "multiply")
                            .foregroundColor(appViewModel.fontColor)
                            .onTapGesture {
                                messagesViewModel.showSendSingleUserMessageSheet = false
                            }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func UserCard(user: User) -> some View {
        VStack {
            
            if let settings = user.settings {
                
                ZStack {
                    Image("board")
                    
                    Text(settings.gardenName)
                        .bodyStyle(foregroundColor: appViewModel.fontColor)
                        .font(.system(size: 13))
                        .lineLimit(1)
                        .frame(width: 100)
                        .truncationMode(.tail)
                        .padding(.horizontal)
                    
                }
                
                ZStack {
                    Circle()
                        .fill(selectedUser != nil && selectedUser!.id == user.id ? Color.appleGreen : Color.white)
                        .opacity(0.7)
                        .frame(width: 120, height: 120)
                    
                    
                    Image("\(settings.treeColor)-\(addDash(settings.tree))")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                    
                    
                }
                
                //                Text(user.name)
                //                    .bodyStyle(foregroundColor: appViewModel.fontColor)
                //                    .font(.system(size: 13))
                //                    .lineLimit(1)
            }
        }
    }
}

struct SendSingleUserMessage_Previews: PreviewProvider {
    static let settings = UserSettings(tree: "sad holly", treeColor: "grenadier")
    static let user = User(id: UUID().uuidString, name: "Pape Sow Traore", settings: settings)
    static var previews: some View {
        SendSingleUserMessage()
            .environmentObject(MessagesViewModel())
            .environmentObject(AppViewModel())
            .environmentObject(CommunityViewModel())
    }
}
