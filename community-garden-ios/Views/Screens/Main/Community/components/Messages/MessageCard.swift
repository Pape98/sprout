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
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State var isShowingSheet = false
    
    var userFlower: String {
        if messageType == .received {
            return message.senderFlower
        } else {
            let settings = UserService.shared.user.settings!
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
                    .padding(.leading)
                
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack {
                        Text(message.isPrivate ? "Anonymous User" : username)
                            .bodyStyle(foregroundColor: .black)
                        
                        Spacer()
                        
                        Text(message.date.getFormattedDate(format: "MMM d"))
                            .bodyStyle(foregroundColor: .chalice)
                        
                    }
                    
                    Text(message.text)
                        .bodyStyle(foregroundColor: .black, size: 13)
                    
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .opacity(0.7)
            }
        }
    }
}

struct MessageCard_Previews: PreviewProvider {
    
    static var message = Message(senderID: "", senderName: "Sender Name",
                                 receiverID: "", receiverName: "Receiver Name",
                                 receiverFcmToken: "", text: "Lundi matin le roi sa femme et le petit prince",
                                 date: Date.now, senderFlower: "grenadier-joyful-clover")
    
    static var previews: some View {
        ZStack {
            Color.hawks
            MessageCard(message: message, messageType: .received)
                .environmentObject(AppViewModel())
        }
    }
}
