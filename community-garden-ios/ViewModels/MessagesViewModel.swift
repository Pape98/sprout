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
    
    // TODO: Remove later
    @Published var showSendSingleUserMessageSheet = false
    @Published var showSendCommunityMessageSheet = false
    @Published var showUserMessageSheet = false
    @Published var showCommunityFeed = false
    
    var selectedUser: User? = nil
    
    // Messages
    @Published var receivedMessages: [Message] = []
    @Published var sentMessages: [Message] = []
    @Published var feedMessages: [CommunityMessage] = []
    
    
    init(){
        getUserMessages()
        getCommunityFeed()
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
                        
        messagesRepository.sendMessage(newMessage, collectionName: CollectionName.messages)
        SproutAnalytics.shared.individualMessage(senderID: sender.id,
                                                 senderName: sender.name,
                                                 receiverID: receiver.id,
                                                 receiverName: receiver.name)
    }
    
    func sendCommunityMessage(text: String, isPrivate: Bool){
        let user = UserService.shared.user
        let message = CommunityMessage(senderID: user.id,
                                       senderName: user.name,
                                       date: Date(),
                                       group: user.group,
                                       isPrivate: isPrivate,
                                       text: text)
        
        messagesRepository.sendMessage(message, collectionName: CollectionName.communityFeed)
        
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
        
        messagesRepository.getMessages(query: receivedMessagesQuery, type: Message.self) { receivedMessages in
            self.messagesRepository.getMessages(query: sentMessagesQuery, type: Message.self) { sentMessages in
                DispatchQueue.main.async {
                    self.receivedMessages = receivedMessages
                    self.sentMessages = sentMessages
                }
            }
        }
    }
    
    func getCommunityFeed(){
        let group = UserService.shared.user.group
        let collection = collections.getCollectionReference(CollectionName.communityFeed.rawValue)
        guard let collection = collection else { return }
                
        let query = collection.whereField("group", isEqualTo: group)
        
        messagesRepository.getMessages(query: query, type: CommunityMessage.self) { feedMessages in
            self.feedMessages = feedMessages
        }
        
    }
}
