//
//  ColorPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/06/2022.
//

import SwiftUI

struct ColorPicker: View {
    var body: some View {
        ZStack {
            Image("sky-cloud-bg")
                .resizable()
                .ignoresSafeArea()
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker()
    }
}
