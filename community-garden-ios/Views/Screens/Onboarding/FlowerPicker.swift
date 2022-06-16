//
//  PetalPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 15/06/2022.
//

import SwiftUI

struct FlowerPicker: View {
    var body: some View {
        Picker(header: "Choose your flower!",
               subheader: "This will be used to track your steps",
               options: Constants.flowers,
               nextScreen: AnyView(Dashboard()),
               circleType: PickerCard.CircleType.FLOWER
        ).userDefaultsKey(UserDefaultsKey.FLOWER)
    }
}

struct FlowerPicker_Previews: PreviewProvider {
    static var previews: some View {
        FlowerPicker()
    }
}
