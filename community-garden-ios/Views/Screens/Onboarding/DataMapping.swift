//
//  DataMapping.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/06/2022.
//

import SwiftUI

struct Custom: View {
    
    var p: Point
    
    var body: some View {
        Circle()
            .fill(.green)
            .position(x: p.x, y: p.y)
            .frame(width: 10, height: 10)
    }
}

struct Point: Hashable {
    var x: CGFloat
    var y: CGFloat
}

struct DataMapping: View {
    
    let userDefaultsService: UserDefaultsService = UserDefaultsService.shared
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    var selectedData: [String] {
        UserDefaultsService.shared.getArray(key: UserDefaultsKey.DATA) ?? ["Steps"]
    }
    
    @State var points: [Point] = []
    
    
    var body: some View {
        
        VStack {
            PickerTitle(header: "I want to see...", subheader: "Decide what data represents what element")
            
            
            VStack {
                
                ForEach(selectedData, id: \.self){ data in
                    Text(data)
                }
            }
            .padding()

            
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
