//
//  TreePicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import SwiftUI


struct TreePicker: View {
        
    var body: some View {
        ItemPicker(header: "Pick a tree!",
               subheader: "Scroll to see all the trees 🌳 ",
               options: Constants.trees,
               circleType: PickerCard.CircleType.TREE
        ).userDefaultsKey(UserDefaultsKey.TREE)
    }
}

struct TreeColorPicker: View {
    var body: some View {
        ColorPicker(
            header: "Pick a color!",
            subheader: "Look at all these nice colors 🎨")
    }
}


struct TreePicker_Previews: PreviewProvider {
    static var previews: some View {
        TreePicker()
    }
}
