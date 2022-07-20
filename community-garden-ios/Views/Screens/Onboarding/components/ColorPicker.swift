//
//  ColorPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/06/2022.
//

import SwiftUI

struct ColorPicker: View {
    
    @Environment(\.dataString) var settingKey
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    var header: String
    var subheader: String
    @Binding var selectedColor: String
    
    
    let userDefaults = UserDefaultsService.shared
    
    
    var DEFAULT_TREE: String {
        onboardingRouter.getSetting(key: FirestoreKey.TREE) as! String
    }
    
    var DEFAULT_FLOWER: String {
        onboardingRouter.getSetting(key: FirestoreKey.FLOWER) as! String
    }
    
    var DEFAULT: String {
        settingKey == FirestoreKey.TREE_COLOR.rawValue ? DEFAULT_TREE : DEFAULT_FLOWER
    }
    
    var imagePath: String {
        if settingKey == FirestoreKey.FLOWER_COLOR.rawValue {
            return "flowers/\(selectedColor)-\(DEFAULT)"
        } else {
            return "\(selectedColor)-\(DEFAULT)"
        }
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                
                VStack {
                    PickerTitle(header: header, subheader: "\(formatItemName(DEFAULT)) 🎨")
                    
                    
                    ZStack(alignment: .bottom) {
                        
                        Image(imagePath)
                            .resizable()
                            .scaledToFit()
                            .zIndex(1)
                            .offset(y: -20)
                            .frame(width: 200.0, height: 250)
                        
                        
                        Image("ground")
                            .resizable()
                            .frame(maxHeight: geometry.size.height * 0.15)
                    }.frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.4)
                        .padding(.vertical)
                    
                    
                    ColorOptionsScroll(selectedColor: $selectedColor)
                    
                    Spacer()
                    
                    BackNextButtons(){
                        // Save selected color
                        let key = FirestoreKey(rawValue: settingKey)
                        if let key = key {
                            onboardingRouter.saveSetting(key: key, value: selectedColor)
                        }
                    }
                    .environmentObject(onboardingRouter)
                }
            }
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    
    @State static var selectedColor = "moss"
    
    static var previews: some View {
        ColorPicker(header: "Choose tree color",
                    subheader: "Look at all these nice colors 🎨",
                    selectedColor: $selectedColor)
        .dataString(FirestoreKey.TREE.rawValue)
        .environmentObject(OnboardingRouter())
    }
}
