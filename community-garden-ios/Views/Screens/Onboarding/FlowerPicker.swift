//
//  PetalPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 15/06/2022.
//

import SwiftUI

struct FlowerPicker: View {
    
    @State var selection = "abyss-sage"
    
    var body: some View {
        ItemPicker(header: "Pick a flower!",
               subheader: "Scroll to see all the flowers 🌸",
                   selection: $selection,
               options: Constants.flowers,
               circleType: PickerCard.CircleType.FLOWER
        ).userDefaultsKey(UserDefaultsKey.FLOWER)
    }
}

struct FlowerPicker_Previews: PreviewProvider {
    static var previews: some View {
        FlowerPicker()
    }
}
