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
    
    let userDefaults: UserDefaultsService = UserDefaultsService.shared
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    var selectedData: [String] {
        userDefaults.getArray(key: UserDefaultsKey.DATA) ?? ["Steps"]
    }
    var treeType: String {
        userDefaults.getString(key:UserDefaultsKey.TREE) ?? "spiky-maple"
    }
    var treeColor: String {
        userDefaults.getString(key:UserDefaultsKey.TREE_COLOR) ?? "moss"
    }
    var flowerType: String {
        userDefaults.getString(key:UserDefaultsKey.FLOWER) ?? "joyful-clover"
    }
    var flowerColor: String {
        userDefaults.getString(key:UserDefaultsKey.FLOWER_COLOR) ?? "cosmos"
    }
    
    @State var points: [Point] = []
    
    
    var body: some View {
        
        VStack {
            PickerTitle(header: "I want to see...", subheader: "Decide what data represents what element")
            
            VStack(spacing: 20){
                Text(treeType)
                Text(treeColor)
                Text(flowerType)
                Text(flowerColor)
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
