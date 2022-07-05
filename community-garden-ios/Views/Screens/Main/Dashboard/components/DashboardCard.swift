//
//  DashboardCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import SwiftUI

struct DashboardCard<Content: View>: View {
    
    var icon: String
    @ViewBuilder var content: Content
    
    var body: some View {
        
        content
            .frame(maxWidth: .infinity ,minHeight: 80, maxHeight: 80)
            .padding(.vertical, 20)
            .background{
                ZStack (alignment: .topLeading) {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(10)
                        .opacity(0.9)
                        .frame(maxWidth: .infinity)
                    
                    Image(systemName: icon)
                        .padding(10)
                        .foregroundColor(.appleGreen)
                }
            }
    }
}

struct DashboardCard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardCard(icon: "calendar-icon") {
            Text("Card")
                .headerStyle()
        }
    }
}
