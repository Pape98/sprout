//
//  TreePicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import SwiftUI


struct TreePicker: View {
    
    @State private var selection: String = "spiky-maple"
    let userDefaults = UserDefaultsService.shared
        
    var body: some View {
        ItemPicker(header: "Pick a tree!",
               subheader: "Scroll to see all the trees 🌳",
               selection: $selection,
               options: Constants.trees,
               circleType: PickerCard.CircleType.TREE
        ).dataString(FirestoreKey.TREE.rawValue)
    }
}

struct TreeColorPicker: View {
    
    @State private var selectedColor = "moss"
    
    var body: some View {
        ColorPicker(
            header: "Pick a color!",
            subheader: "Look at all these nice colors 🎨",
            selectedColor: $selectedColor)
        .dataString(FirestoreKey.TREE_COLOR.rawValue)
    }
}


struct TreePicker_Previews: PreviewProvider {
    static var previews: some View {
        TreePicker()
            .environmentObject(OnboardingRouter())
    }
}
