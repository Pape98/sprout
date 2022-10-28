//
//  CommunityFeedCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 28/10/2022.
//

import SwiftUI

struct CommunityFeedCard: View {
    
    var message: CommunityMessage
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    
    var body: some View {
        VStack {
            HStack {
                
                CircledFlower(option: message.senderFlower, background: .appleGreen)
                    .frame(width: 55, height: 55)
                    .padding(.leading)
                
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack {
                        Text(message.isPrivate ? "Anonymous User" : message.senderName)
                            .bodyStyle(foregroundColor: .seaGreen)
                        
                        Spacer()
                        
                        HStack(alignment: .center) {
                            Text(message.date.getFormattedDate(format: "MMM d"))
                                .bodyStyle(foregroundColor: .chalice)
                            Image(systemName: "calendar")
                                .foregroundColor(.appleGreen)
                        }
                        
                    }
                    
                    Text(message.text)
                        .bodyStyle(foregroundColor: .seaGreen, size: 13)
                    
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .opacity(0.5)
            }
        }
    }
}

struct CommunityFeedCard_Previews: PreviewProvider {
    static let message = CommunityMessage(id: "", senderID: "Pape", senderName: "Pape", date: Date(), isPrivate: true, text: "This is a message", senderFlower: "grenadier-joyful-clover", group: 1)
    static var previews: some View {
        ZStack {
            Color.hawks
            CommunityFeedCard(message: message)
        }
    }
}
