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
    
    @Published var options = [
        MessageOption(text: "Proud of you!", color: "cosmos", isDefault: true),
        MessageOption(text: "You are the best!", color: "sunglow", isDefault: true),
        MessageOption(text: "You are amazing!", color: "lavender", isDefault: true),
        MessageOption(text: "Have a wonderful day!", color: "tangerine", isDefault: true),
        
    ]
    
    @Published var customUptions: [MessageOption] = []
    @Published var showMessageOptionsSheet = false
    var selectedUser: User? = nil
    
    // Messages
    @Published var receivedMessages: [Message] = []
    @Published var sentMessages: [Message] = []
    
    
    init(){
        initializeCustomOptions()
        getUserMessages()
    }
    
    func initializeCustomOptions(){
        let userDefaultsOptions: Data? = userDefaults.get(key: UserDefaultsKey.MESSAGE_OPTIONS)
        if let userDefaultsOptions = userDefaultsOptions {
            let decodedOptions = dataArrayDecoder(data: userDefaultsOptions, type: MessageOption.self)
            DispatchQueue.main.async {
                self.customUptions = decodedOptions
            }
        }
    }
    
    func addOption(text: String, color: String){
        let newOption = MessageOption(text: text, color: color, isDefault: false)
        var userOptions = self.customUptions
        userOptions.append(newOption)
        if let encodedOptions: Data = dataEncoder(data: userOptions) {
            userDefaults.save(value: encodedOptions, key: UserDefaultsKey.MESSAGE_OPTIONS)
            initializeCustomOptions()
        }
    }
    
    func deleteOption(){
        let userDefaultsOptions: Data? = userDefaults.get(key: UserDefaultsKey.MESSAGE_OPTIONS)
        if let userDefaultsOptions = userDefaultsOptions {
            
            var decodedOptions = dataArrayDecoder(data: userDefaultsOptions, type: MessageOption.self)
            decodedOptions = decodedOptions.filter { $0.text != self.messageToDelete }
            self.messageToDelete = ""
            
            if let encodedOptions: Data = dataEncoder(data: decodedOptions) {
                userDefaults.save(value: encodedOptions, key: UserDefaultsKey.MESSAGE_OPTIONS)
                initializeCustomOptions()
            }
        }
    }
    
    // MARK: Methods for sending and receiving messages
    func sendMessage(receiver: User, text: String, isPrivate: Bool){
        let sender = UserService.user
        guard sender.settings != nil else { return }
        let newMessage = Message(senderID: sender.id, senderName: sender.name,
                                 receiverID: receiver.id, receiverName: receiver.name,
                                 receiverFcmToken: receiver.fcmToken,
                                 text: text, isPrivate: isPrivate, date: Date.now,
                                 senderFlower: "\(sender.settings!.flowerColor)-\(addDash(sender.settings!.flower))"
        )
                
        messagesRepository.sendMessage(newMessage)
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
