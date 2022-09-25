//
//  MessageCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 23/08/2022.
//

import SwiftUI

struct MessageCard: View {
    
    var message: Message
    var messageType: ViewMessageType
    
    @State var isShowingSheet = false
    
    var userFlower: String {
        if messageType == .received {
            return message.senderFlower
        } else {
            let settings = UserService.user.settings!
            return "\(settings.flowerColor)-\(addDash(settings.flower))"
        }
    }
    
    var username: String {
        messageType == .received ? message.senderName :message.receiverName
        
    }
    
    var flowerColor: Color {
        messageType == .received ? .seaGreen : .white
    }
    
    var body: some View {
        VStack {
            HStack {
                
                CircledFlower(option: userFlower, background: flowerColor)
                    .frame(width: 55, height: 55)
                
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack {
                        Text(message.isPrivate ? "Anonymous" : username)
                            .font(.system(size: 15))
                            .bold()
                        
                        Spacer()
                        
                        Text(message.date.getFormattedDate(format: "MMM d"))
                            .font(.system(size: 13))
                            .foregroundColor(.chalice)
                            .bold()
                        
                    }
                    
                    Text(message.text)
                        .font(.system(size: 13))
                    
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
        }
        .sheet(isPresented: $isShowingSheet, content: {
           
        })
    }
}

struct MessageCard_Previews: PreviewProvider {
    
    static var message = Message(senderID: "", senderName: "Sender Name",
                                 receiverID: "", receiverName: "Receiver Name",
                                 receiverFcmToken: "", text: "Lundi matin le roi sa femme et le petit prince",
                                 date: Date.now, senderFlower: "grenadier-joyful-clover")
    
    static var previews: some View {
        MessageCard(message: message, messageType: .received)
    }
}
