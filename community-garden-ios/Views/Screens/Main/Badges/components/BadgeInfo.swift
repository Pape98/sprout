//
//  BadgeInfo.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/10/2022.
//

import SwiftUI

struct BadgeInfo: View {
    
    var badge: CommunityBadge
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top){
                MainBackground(image: "sky-cloud-bg")
                
                VStack(spacing: 30) {
                    
                    Spacer(minLength: 0)
                    
                    Image("badges/\(badge.name)")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 125)
                    
                    HStack(alignment: .center) {
                        Image(systemName: "target")
                            .foregroundColor(.appleGreen)
                        Text("\(badge.numberOfDaysRequired)")
                            .bodyStyle()
                    }

                    JustifiedText(badge.description + "" + badge.note)
                    
                }
                .padding()
                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.9, alignment: .top)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .opacity(0.7)
                }
                
                .navigationBarTitle(badge.name.capitalized)
            }
        }
    }
}

struct BadgeInfo_Previews: PreviewProvider {
    static let badge = CommunityBadge(name: "turtle")
    static var previews: some View {
        BadgeInfo(badge: badge)
    }
}
