//
//  ColorPicker.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/06/2022.
//

import SwiftUI

struct ColorPicker: View {
    
    var header: String
    var subheader: String
    var nextScreen: AnyView
    let DEFAULT_TREE = UserDefaultsService.shared.getString(key: UserDefaultsKey.TREE) ?? "spiky-maple"
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State var selectedColor = "moss"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image("sky-cloud-bg")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    
                    VStack {
                        Text(header)
                            .headerStyle()
                        Text("\(formatItemName(DEFAULT_TREE)) 🎨")
                            .bodyStyle()
                    }.padding()
                    
                    
                    ZStack(alignment: .bottom) {
                        Image("\(selectedColor)-\(DEFAULT_TREE)")
                            .resizable()
                            .scaledToFit()
                            .zIndex(1)
                            .offset(y: -15)
                        
                        Image("ground")
                            .resizable()
                            .frame(maxHeight: geometry.size.height * 0.1)
                    }.frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.4)
                        .padding(.vertical)
                    
                    
                    ColorOptionsScroll(selectedColor: $selectedColor)
                    
                    Spacer()
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        PickerButton(text: "Back",
                                     selection: selectedColor)
                        
                        PickerButton(text: "Next",
                                     selection: selectedColor,
                                     nextScreen: nextScreen)
                        
                    }.padding()
                }
            }.navigationBarHidden(true)
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ColorPicker(header: "Choose tree color",
                    subheader: "Look at all these nice colors 🎨",
                    nextScreen: AnyView(Dashboard())
        )
    }
}
