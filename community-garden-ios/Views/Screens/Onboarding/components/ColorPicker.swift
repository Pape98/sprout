//
//  ColorPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/06/2022.
//

import SwiftUI

struct ColorPicker: View {
    
    @Environment(\.userDefaultsKey) var userDefaultsKey
    var header: String
    var subheader: String
    @Binding var selectedColor: String
    
    
    let userDefaults = UserDefaultsService.shared
    
    
    var DEFAULT_TREE: String {
        userDefaults.get(key: UserDefaultsKey.TREE) ?? "spiky-maple"
    }
    
    var DEFAULT_FLOWER: String {
        userDefaults.get(key: UserDefaultsKey.FLOWER) ?? "abyss-sage"
    }
    
    var DEFAULT: String {
        userDefaultsKey == UserDefaultsKey.TREE_COLOR ? DEFAULT_TREE : DEFAULT_FLOWER
    }
    
    var imagePath: String {
        if userDefaultsKey == UserDefaultsKey.FLOWER_COLOR {
            return "flowers/\(selectedColor)-\(DEFAULT)"
        } else {
            return "\(selectedColor)-\(DEFAULT)"
        }
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
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
                        userDefaults.save(value: selectedColor, key: userDefaultsKey)
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
        .userDefaultsKey(UserDefaultsKey.TREE)
        .environmentObject(OnboardingRouter())
    }
}
