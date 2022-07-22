//
//  FriendsList.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 5/23/22.
//

import SwiftUI
import SpriteKit

enum FriendsListViewMode {
    case basic
    case scene
}

struct FriendsList: View {
    
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    @State var viewMode: FriendsListViewMode = .basic
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    
                    MainBackground()
                    
                    ScrollView {
                        
                        VStack(spacing: 15) {
                            ForEach(friendsViewModel.friendsGardens){ garden in
                                NavigationLink {
                                    FriendGarden(garden: garden)
                                } label: {
                                    if viewMode == .scene {
                                        SceneCard(garden: garden)
                                    } else {
                                        FriendListBasicCard(user: garden.user)
                                    }
                                    
                                }
                            }
                        }
                        .padding()
                        
                    }
                }
                .navigationBarTitle("My Friends", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Picker("View Mode", selection: $viewMode) {
                            
                            
                            Image(systemName: "rectangle.grid.1x2")
                                .foregroundColor(Color.appleGreen)
                                .tag(FriendsListViewMode.basic)
                            
                            
                            Image(systemName: "camera.macro.circle")
                                .foregroundColor(Color.appleGreen)
                                .tag(FriendsListViewMode.scene)
                        }
                    }
                }
                .onAppear {
                    friendsViewModel.fetchAllCurrentItems()
                }
            }
            .navigationViewStyle(.stack)
        }
    }
    
    @ViewBuilder
    func SceneCard(garden: UserGarden) -> some View {
        
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

struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsList()
            .environmentObject(FriendsViewModel())
    }
}
