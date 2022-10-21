//
//  PetalPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 15/06/2022.
//

import SwiftUI

struct FlowerPicker: View {
    
    @State private var selection = "abyss-sage"
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    var body: some View {
        ItemPicker(header: "Pick a flower!",
                   subheader: "Scroll to see all the flowers 🌸",
                   selection: $selection,
                   options: Constants.flowers,
                   circleType: PickerCard.CircleType.FLOWER
        ).dataString(FirestoreKey.FLOWER.rawValue)
            .onAppear {
                if onboardingRouter.canCustomize() == false {
                    onboardingRouter.saveSetting(key: FirestoreKey.FLOWER, value: "joyful-clover")
                    onboardingRouter.navigateNext()
                }
            }
    }
}

struct FlowerColorPicker: View {
    
    @State private var selectedColor = "cosmos"
    
    var body: some View {
        ColorPicker(
            header: "Pick a color!",
            subheader: "Look at all these nice colors 🎨",
            selectedColor: $selectedColor)
        .dataString(FirestoreKey.FLOWER_COLOR.rawValue)
    }
}

struct FlowerPicker_Previews: PreviewProvider {
    static var previews: some View {
        FlowerPicker()
            .environmentObject(OnboardingRouter())
    }
}
