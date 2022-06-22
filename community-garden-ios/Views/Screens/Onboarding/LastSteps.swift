//
//  LastSteps.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 21/06/2022.
//

import SwiftUI

struct LastSteps: View {
    
    var userDefaults = UserDefaultsService.shared

    
    var body: some View {
        VStack(spacing: 25){
            Text("Last Steps")
         
        }
    }
}

struct LastSteps_Previews: PreviewProvider {
    static var previews: some View {
        LastSteps()
    }
}
