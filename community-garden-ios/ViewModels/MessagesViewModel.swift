//
//  MessagesViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 21/07/2022.
//

import Foundation

class MessagesViewModel: ObservableObject {
    
    static let shared = MessagesViewModel()
    let userDefaults = UserDefaultsService.shared
    let messagesRepository = MessagesRepository.shared
    var messageToDelete = ""
    let collections = Collections.shared
    

    
    @Published var customUptions: [MessageOption] = []
    // TODO: Remove later
    @Published var showMessageOptionsSheet = false
    @Published var showSendMessageSheet = false
    var selectedUser: User? = nil
    
    // Messages
    @Published var receivedMessages: [Message] = []
    @Published var sentMessages: [Message] = []
    
    
    init(){
        getUserMessages()
    }
    
    // MARK: Methods for sending and receiving messages
    func sendMessage(receiver: User, text: String, isPrivate: Bool){
        let sender = UserService.shared.user
        guard sender.settings != nil else { return }
        let newMessage = Message(senderID: sender.id, senderName: sender.name,
                                 receiverID: receiver.id, receiverName: receiver.name,
                                 receiverFcmToken: receiver.fcmToken,
                                 text: text, isPrivate: isPrivate, date: Date.now,
                                 senderFlower: "\(sender.settings!.flowerColor)-\(addDash(sender.settings!.flower))"
        )
                        
        messagesRepository.sendMessage(newMessage)
        SproutAnalytics.shared.individualMessage(senderID: sender.id,
                                                 senderName: sender.name,
                                                 receiverID: receiver.id,
                                                 receiverName: receiver.name)
    }
    
    func getUserMessages(){
        let userID = getUserID()
        let collection = collections.getCollectionReference(CollectionName.messages.rawValue)
        
        guard let collection = collection, let userID = userID else { return }
        
        let receivedMessagesQuery = collection
            .whereField("receiverID", isEqualTo: userID)
            .order(by: "date", descending: true)
        
        let sentMessagesQuery = collection
            .whereField("senderID", isEqualTo: userID)
            .order(by: "date", descending: true)
        
        messagesRepository.getMessages(query: receivedMessagesQuery) { receivedMessages in
            self.messagesRepository.getMessages(query: sentMessagesQuery) { sentMessages in
                DispatchQueue.main.async {
                    self.receivedMessages = receivedMessages
                    self.sentMessages = sentMessages
                }
            }
        }
        
    }
}
