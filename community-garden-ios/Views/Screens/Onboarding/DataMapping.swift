//
//  DataMapping.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/06/2022.
//

import SwiftUI

struct DataMapping: View {
    
    let userDefaultsService: UserDefaultsService = UserDefaultsService.shared
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    var selectedData: [String] {
        UserDefaultsService.shared.getArray(key: UserDefaultsKey.DATA) ?? ["Steps"]
    }

    
    var body: some View {
        VStack {
            PickerTitle(header: "I want to see...", subheader: "Decide what data represents what element")
            List(selectedData, id: \.self) {
                Text($0)
            }
            
            Spacer()
            BackNextButtons()
                .environmentObject(onboardingRouter)
        }
    }
}

struct DataMapping_Previews: PreviewProvider {
    static var previews: some View {
        DataMapping()
            .environmentObject(OnboardingRouter())
    }
}
