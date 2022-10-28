//
//  Badges.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/10/2022.
//

import SwiftUI

struct Badges: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let constants = Constants.shared
    
    var badges: [CommunityBadge] {
        return Array(Constants.badges.values).sorted(by: { b1, b2 in
            b1.numberOfDaysRequired < b2.numberOfDaysRequired
        })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                MainBackground()
                
                ScrollView {
                    VStack {
                        
                        Text("Tap badge to view")
                            .bodyStyle()
                        
                        LazyVGrid(columns: columns, spacing: 40) {
                            ForEach(badges, id: \.self) { badge in
                                
                                if appViewModel.numFiftyPercentDays >= badge.numberOfDaysRequired {
                                    NavigationLink {
                                        BadgeInfo(badge: badge)
                                    } label: {
                                        VStack {
                                            
                                            Image("badges/\(badge.name)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100)
                                            
                                            ProgressView("", value: min(CGFloat(appViewModel.numFiftyPercentDays / badge.numberOfDaysRequired), 1))
                                                .frame(width: 100)
                                            
                                            
                                            HStack(alignment: .center) {
                                                Image(systemName: "target")
                                                    .foregroundColor(.appleGreen)
                                                Text("\(min(appViewModel.numFiftyPercentDays,badge.numberOfDaysRequired)) /\(badge.numberOfDaysRequired) day(s)")
                                                    .bodyStyle()
                                            }
                                        }
                                    }
                                }
                                
                                else {
                                    VStack {
                                        
                                        ZStack(alignment: .center) {
                                            Image("badges/\(badge.name)")
                                                .resizable()
                                                .scaledToFit()
                                                .saturation(0)
                                                .blur(radius: 1.5)
                                            
                                            Image(systemName: "lock.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30)
                                                .foregroundColor(Color.appleGreen)
                                        }
                                        .frame(width: 100)
                                        
                                        ProgressView("", value: CGFloat(appViewModel.numFiftyPercentDays / badge.numberOfDaysRequired))
                                            .frame(width: 100)
                                        
                                        
                                        HStack(alignment: .center) {
                                            Image(systemName: "target")
                                                .foregroundColor(.appleGreen)
                                            Text("\( min(appViewModel.numFiftyPercentDays,badge.numberOfDaysRequired)) / \(badge.numberOfDaysRequired) day(s)")
                                                .bodyStyle()
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding(.top)
                }
                
                FloatingAnimal()
            }
            .navigationTitle("Community Badges 📛")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct Badges_Previews: PreviewProvider {
    static var previews: some View {
        Badges()
            .environmentObject(AppViewModel())
            .environmentObject(BadgesViewModel())
    }
}
