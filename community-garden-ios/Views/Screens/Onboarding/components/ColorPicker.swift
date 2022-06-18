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
        ZStack(alignment: .top) {
            Image("sky-cloud-bg")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                VStack {
                    Text(header)
                        .headerStyle()
                    Text(subheader)
                        .bodyStyle()
                }.padding()
                
//                CircledTree(option: "\(selectedColor)-\(DEFAULT_TREE)",
//                            background: .oliveGreen,
//                            size: 180)
//                .frame(height: 190)
//                
                Image("\(selectedColor)-\(DEFAULT_TREE)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 210)
                
                Text("Pick a color 😊")
                    .bodyStyle()
                
                ColorOptionsScroll(selectedColor: $selectedColor)
                
                Spacer()
                
                LazyVGrid(columns: columns, spacing: 20) {
                    PickerButton(text: "Back",
                                 selection: selectedColor)
                    
                    PickerButton(text: "Next",
                                 selection: selectedColor,
                                 nextScreen: nextScreen)
                    
                }
                .padding()
            }
        }.navigationBarHidden(true)
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
