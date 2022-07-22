//
//  GardenInfoCard.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/7/22.
//

import SwiftUI

struct GardenInfoCard: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    let today = Date()
    
    let userDefaults = UserDefaultsService.shared
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            HStack {
                
                // Buttons
                if let numDroplets = userViewModel.numDroplets {
                    IconButton(icon: "droplet-icon", text: "\(Int(numDroplets.value)) droplets")
                }
                
                if let numSeeds = userViewModel.numSeeds {
                    IconButton(icon: "seed-icon", text: "\(Int(numSeeds.value)) seeds")
                }
                
                if let settings = userViewModel.currentUser.settings {
                    NavigationLink(destination: MyGarden()) {
                        IconButton(icon: "garden-icon", text: settings.gardenName)
                            .shadow(color: .chalice, radius: 4, x: -2, y: 1)
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
        
        GardenInfoCard()
            .environmentObject(UserViewModel())
    }
}
