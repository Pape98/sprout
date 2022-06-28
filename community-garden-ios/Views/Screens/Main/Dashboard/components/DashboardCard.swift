//
//  DashboardCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import SwiftUI

struct DashboardCard<Content: View>: View {
    
    var width: CGFloat
    var icon: String
    @ViewBuilder var content: Content
    
    var body: some View {
        
        content
            .frame(width: width, height: 60)
            .padding(.vertical, 20)
            .background{
                ZStack (alignment: .topLeading) {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(10)
                        .opacity(0.9)
                    
                    Image(icon)
                        .padding(10)
                }
            }
    }
}

struct DashboardCard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardCard(width: 100, icon: "calendar-icon") {
            Text("Card")
                .headerStyle()
        }
    }
}
