//
//  CommunityMessageCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 28/10/2022.
//

import SwiftUI

struct CommunityFeed: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                MainBackground()
                
                // Message type selection
                
                VStack {
                    
                    ScrollView {
                        
                        VStack (spacing: 12.5){
                            ForEach(messagesViewModel.feedMessages){ message in
                                CommunityFeedCard(message: message)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                
                FloatingAnimal(animal: "koala-laughing")
                
            }
            .navigationBarTitle("Community Feed 🌍", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    
                    Button {
                        messagesViewModel.getCommunityFeed()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(appViewModel.fontColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(appViewModel.fontColor)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func formatDate(_ date: Date) -> String {
        return date.getFormattedDate(format: "MMM d, yyyy")
    }
    
}

struct CommunityFeed_Previews: PreviewProvider {
    static var previews: some View {
        CommunityFeed()
            .environmentObject(AppViewModel())
            .environmentObject(MessagesViewModel())
    }
}
