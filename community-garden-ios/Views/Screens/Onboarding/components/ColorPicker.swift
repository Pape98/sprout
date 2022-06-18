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
    let DEFAULT_TREE = UserDefaultsService.shared.getString(key: UserDefaultsKey.TREE) ?? "spiky-maple"
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    @State var selectedColor = "moss"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                
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
                    
                    BackNextButtons()
                        .environmentObject(onboardingRouter)
                }
            }
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ColorPicker(header: "Choose tree color",
                    subheader: "Look at all these nice colors 🎨")
        .environmentObject(OnboardingRouter())
    }
}
