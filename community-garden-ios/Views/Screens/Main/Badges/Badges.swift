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
    
    var body: some View {
        NavigationView {
            ZStack {
                MainBackground(image: "sky-cloud-bg")
                
                ScrollView {
                    VStack {
                        
                        Text("Tap badge to view")
                            .bodyStyle()
                        
                        LazyVGrid(columns: columns, spacing: 40) {
                            ForEach(Constants.badges, id: \.self) { badge in
                                
                                if appViewModel.numFiftyPercentDays >= badge.numberOfDaysRequired {
                                    NavigationLink {
                                        BadgeInfo(badge: badge)
                                    } label: {
                                        VStack {
                                            
                                            Image("badges/\(badge.name)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100)
                                            
                                            ProgressView("", value: CGFloat(appViewModel.numFiftyPercentDays / badge.numberOfDaysRequired))
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
                                        
                                        Image("badges/locked")
                                            .resizable()
                                            .scaledToFit()
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
                        
                        Spacer()
                    }
                    .padding(.top)
                }
                
                FloatingAnimal()
            }
            .navigationTitle("Community Badges")
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
