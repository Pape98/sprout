//
//  TreePicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 6/6/22.
//

import SwiftUI


struct TreePicker: View {
        
    var body: some View {
        Picker(header: "Choose your tree!",
               subheader: "This will be used to track your steps",
               options: Constants.trees,
               nextScreen: AnyView(FlowerPicker()),
               circleType: PickerCard.CircleType.TREE
        ).userDefaultsKey(UserDefaultsKey.TREE)
    }
}


struct TreePicker_Previews: PreviewProvider {
    static var previews: some View {
        TreePicker()
    }
}
