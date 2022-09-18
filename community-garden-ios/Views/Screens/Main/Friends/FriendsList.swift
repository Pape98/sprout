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

enum FriendViewType {
    case friends, community
}

struct FriendsList: View {
    
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    @State var viewMode: FriendsListViewMode = .basic
    @State var selectedGroup = FriendViewType.friends
    
    var gardens: [UserGarden] {
        return friendsViewModel.friendsGardens
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    
                    MainBackground()
                    
                    VStack {
//                        Picker("", selection: $selectedGroup){
//                            Text("Friends").tag(FriendViewType.friends)
//                            Text("Community").tag(FriendViewType.community)
//                        }
//                        .pickerStyle(.segmented)
//                        .padding()
                        
                        ScrollView {
                            
                            VStack(spacing: 15) {
                                ForEach(gardens){ garden in
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
                }
                .navigationBarTitle("Friends", displayMode: .inline)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading){
                        Button("Refresh"){
                            friendsViewModel.fetchAllUsers()
                        }
                        .foregroundColor(Color.black)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        VStack {
                            if viewMode == .basic {
                                Image(systemName: "rectangle.grid.1x2")
                                    .foregroundColor(Color.appleGreen)
                                    .tag(FriendsListViewMode.basic)
                            } else {
                                Image(systemName: "camera.macro.circle")
                                    .foregroundColor(Color.appleGreen)
                                    .tag(FriendsListViewMode.scene)
                            }
                        }
                        .onTapGesture {
                            viewMode = viewMode == .basic ? .scene : .basic
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
