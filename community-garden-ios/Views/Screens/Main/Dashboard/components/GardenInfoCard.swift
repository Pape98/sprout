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
        
            HStack {
                
                // Buttons
                if let numDroplets = userViewModel.numDroplets {
                    IconButton(icon: "droplet-icon", text: "\(Int(numDroplets.value)) droplets")
                }
                
                if let numSeeds = userViewModel.numSeeds {
                    IconButton(icon: "seed-icon", text: "\(Int(numSeeds.value)) beans")
                }
                
            }
            .padding(25)
            .background {
                ZStack (alignment: .leading) {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(10)
                    Image("steps-trace")
                }
            }
            .frame(height: 150)
        
    }
}

struct GardenInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        
        GardenInfoCard()
            .environmentObject(UserViewModel())
    }
}
