//
//  FriendsList.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import SwiftUI
import SpriteKit


struct FriendsList: View {
    
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                
                MainBackground()
                
                ScrollView {
                    VStack {
                        ForEach(friendsViewModel.friendsGardens){ garden in
                            NavigationLink {
                                FriendGarden(garden: garden)
                            } label: {
                                Garden(garden: garden, isAnimated: false)
                                    .background {
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.white)
                                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                    }
                                    .cornerRadius(25)
                                    .frame(height: 300)
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("My Friends", displayMode: .inline)
            .onAppear {
                friendsViewModel.fetchAllCurrentItems()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsList()
            .environmentObject(FriendsViewModel())
    }
}
