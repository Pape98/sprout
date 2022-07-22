//
//  Messages.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 22/07/2022.
//

import SwiftUI

struct Messages: View {
    var body: some View {
        
        NavigationView {
            ZStack {
                MainBackground()
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        Messages()
    }
}
