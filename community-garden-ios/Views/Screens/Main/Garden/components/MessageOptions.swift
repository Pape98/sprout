//
//  MessageOptions.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/07/2022.
//

import SwiftUI

struct MessageOptions: View {
    
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    
    @State private var showSheet = false
    @State private var showDeleteAlert = false
    
    @State private var selectedMessage = MessageOption(text: "Proud of you!", color: "cosmos")
    @State private var isMessagePrivate = true
    
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
                                            size: 120)
                            }
                            
                            Text(user.name)
                                .bodyStyle()
                        }
                        .padding(.top)
                        
                        // Selected Messsage
                        Text(selectedMessage.text)
                            .frame(alignment: .center)
                            .padding()
                            .multilineTextAlignment(.leading)
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
                                Picker("Select Message", selection: $selectedMessage) {
                                    ScrollView {
                                        VStack(spacing: 20) {
                                            ForEach(messagesViewModel.options, id: \.self) { message in
                                                MessageCard(message: message)
                                                    .tag(message)
                                            }
                                        }
                                    }
                                }
                                Toggle("Private Message", isOn: $isMessagePrivate)

                            }
                            
                        }
                        .offset(y: -20)
                    }
                    
                    //                VStack {
                    //                    VStack {
                    //                        if let settings = user.settings {
                    //                            CircledTree(option: "\(settings.treeColor)-\(addDash(settings.tree))",
                    //                                        background: .haze,
                    //                                        size: 75)
                    //                        }
                    //
                    //                        Text(user.name)
                    //                            .bodyStyle()
                    //                    }
                    //                    .padding()
                    //
                    //                    ScrollView {
                    //                        VStack(spacing: 20) {
                    //                            ForEach(messagesViewModel.options, id: \.self) { message in
                    //                                MessageCard(message: message)
                    //                            }
                    //                        }
                    //                        .padding(.horizontal, 40)
                    //                    }
                    //
                    //                    Spacer()
                    //
                    //                }
                }
                .sheet(isPresented: $showSheet, content: {
                    CustomMessageSheet()
                })
                .navigationTitle("Send Message")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showSheet = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.seaGreen)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("sending")
                        } label: {
                            Image(systemName: "paperplane")
                                .foregroundColor(.seaGreen)
                        }
                    }
                }
                .alert(isPresented: $showDeleteAlert){
                    Alert(title: Text("Deleting message"),
                          message: Text("Are you sure you want to delete message?"),
                          primaryButton: .default(
                            Text("Cancel"),
                            action: { () -> () in showDeleteAlert = false }
                          ),
                          secondaryButton: .destructive(
                            Text("Delete"),
                            action: messagesViewModel.deleteOption
                          )
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    func MessageCard(message: MessageOption) -> some View {
        HStack {
            Text(message.text)
                .padding()
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(message.text == selectedMessage.text ? Color(message.color): Color.haze)
                .frame(maxWidth: .infinity, maxHeight: 70)
                .opacity(0.8)
                .onTapGesture {
                    selectedMessage.text = message.text
                }
                .onLongPressGesture(perform: {
                    showDeleteAlert = true
                    messagesViewModel.messageToDelete = message.text
                })
        }
    }
}



struct MessageOptions_Previews: PreviewProvider {
    static let settings = UserSettings(tree: "sad holly", treeColor: "grenadier")
    static let user = User(id: UUID().uuidString, name: "Pape Sow Traore", settings: settings)
    static var previews: some View {
        MessageOptions(user: user)
            .environmentObject(MessagesViewModel())
    }
}
