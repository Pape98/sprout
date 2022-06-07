//
//  GardenInfoCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import SwiftUI

struct GardenInfoCard: View {
    
    var user: User
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            // Steps
            HStack {
                
                if let stepCount = user.stepCount {
                    VStack(alignment: .leading) {
                        Text("\(stepCount.count)")
                            .bold()
                            .headerStyle()
                        Text("Steps")
                            .bold()
                            .bodyStyle()
                    }
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
        let stepCount = Step(date: Date(), count: 25)
        let user: User = User(id: "1", name: "Pape", email: "papisline2222@gmail.com", oldStepCount: 10, stepCount: stepCount, numDroplets: 15, gardenItems: [])
        GardenInfoCard(user: user)
    }
}
