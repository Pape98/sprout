//
//  PetalPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 15/06/2022.
//

import SwiftUI

struct FlowerPicker: View {
    var body: some View {
        ItemPicker(header: "Choose your flower!",
               subheader: "Scroll to see all the flowers 😊",
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
