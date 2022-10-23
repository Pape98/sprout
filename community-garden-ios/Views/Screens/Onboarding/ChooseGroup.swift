//
//  ChooseGroup.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 10/21/22.
//

import SwiftUI

struct ChooseGroup: View {
    
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    var ratio = 0.4
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 5) {
                
                PickerTitle(header: "Select a group", subheader: "")
                
                HStack {
                    Group(number: 0, color: .sunglow, width: geo.size.width , height: geo.size.height)
                    Group(number: 1, color: .grenadier, width: geo.size.width, height: geo.size.height)
                }
                HStack {
                    Group(number: 2, color: .mint, width: geo.size.width, height: geo.size.height)
                    Group(number: 3, color: .moss, width: geo.size.width, height: geo.size.height)
                }
                
                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
    
    @ViewBuilder
    func Group(number: Int, color: Color, width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .opacity(0.75)
            Text("\(number)")
                .font(.custom(Constants.mainFont, size: 100))
                .foregroundColor(.white)
        }
        .frame(width: width * ratio, height: height * ratio, alignment: .center)
        .onTapGesture {
            onboardingRouter.selectedGroup = number
            onboardingRouter.navigateNext()
        }
    }
}

struct ChooseGroup_Previews: PreviewProvider {
    static var previews: some View {
        ChooseGroup()
            .environmentObject(OnboardingRouter())
    }
}
