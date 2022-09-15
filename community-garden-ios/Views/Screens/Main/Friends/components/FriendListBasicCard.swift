//
//  FriendListBasicCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 22/07/2022.
//

import SwiftUI

struct FriendListBasicCard: View {
    
    var user: User
    var tree: String {
        if let settings = user.settings {
            return "\(settings.treeColor)-\(addDash(settings.tree))"
        }
        return "cosmos-sad-holly"
    }
    
    var body: some View {
        HStack(alignment: .center) {
            CircledTree(option: tree, background: .appleGreen, size: 70)
            Text(user.name)
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "arrow.forward")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .padding()
                .foregroundColor(Color.seaGreen)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .opacity(0.75)
        }

    }
}

struct FriendListBasicCard_Previews: PreviewProvider {
    
    static let garden = getSampleUserGarden()
    static var previews: some View {
        
        ZStack {
            FriendListBasicCard(user: garden.user)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.hawks)
        
    }
}
