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
                        LazyVGrid(columns: columns, spacing: 40) {
                            ForEach(1...30, id: \.self) { number in
                                    Circle()
                                    .frame(width: 120)
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
    }
}
