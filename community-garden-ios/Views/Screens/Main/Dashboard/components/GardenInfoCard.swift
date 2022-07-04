//
//  GardenInfoCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import SwiftUI

struct GardenInfoCard: View {
    
    var user: User
    let today = Date()
    
    let userDefaults = UserDefaultsService.shared
    
    var gardenName: String {
        userDefaults.get(key: UserDefaultsKey.GARDEN_NAME) ?? "Poudlard"
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            HStack {
                
                VStack {
                    Text(today.getFormattedDate(format: "dd"))
                        .bold()
                        .headerStyle()
                    Text(today.getFormattedDate(format: "MMMM"))
                        .bold()
                        .bodyStyle()
                }
                
                Spacer()
                
                // Buttons
                HStack(spacing: 10) {
                    IconButton(icon: "droplet-icon", text: "5 droplets")
                    NavigationLink(destination: MyGarden()) {
                        IconButton(icon: "garden-icon", text: gardenName)
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
                    
                    Image("steps-trace")
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
