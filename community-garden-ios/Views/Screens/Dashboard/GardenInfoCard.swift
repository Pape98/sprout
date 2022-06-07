//
//  GardenInfoCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import SwiftUI

struct GardenInfoCard: View {
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            // Steps
            HStack {
                VStack(alignment: .leading) {
                    Text("1247")
                        .bold()
                        .headerStyle()
                    Text("Steps")
                        .bold()
                        .bodyStyle()
                }
                
                Spacer()
                
                // Buttons
                HStack(spacing: 10) {
                    IconButton(icon: "droplet-icon", text: "5 droplets")
                    NavigationLink(destination: MyGarden()) {
                        IconButton(icon: "garden-icon", text: "Your Garden")
                    }
                    
                }
                
            }
            .padding(25)
            .background {
                ZStack (alignment: .leading) {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(10)
                        .opacity(0.9)
                        .shadow(radius: 3)
                    
                    Image("step-icon")
                }
            }
        }
    }
}

struct GardenInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        GardenInfoCard()
    }
}
