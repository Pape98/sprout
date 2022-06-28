//
//  Onboarding.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/06/2022.
//

import SwiftUI

struct Onboarding: View {
    
    @EnvironmentObject var onboardingRouter: OnboardingRouter
    
    var body: some View {
        ZStack {
            Image("sky-cloud-bg")
                .resizable()
                .ignoresSafeArea()
                        
            switch onboardingRouter.currentScreen {
            case .chooseData:
                DataPicker().transition(onboardingRouter.transition)
            case .setGoals:
                GoalsSetting().transition(onboardingRouter.transition)
            case .chooseTree:
                TreePicker().transition(onboardingRouter.transition)
            case .chooseTreeColor:
                TreeColorPicker().transition(onboardingRouter.transition)
            case .chooseFlower:
                FlowerPicker().transition(onboardingRouter.transition)
            case .chooseFlowerColor:
                FlowerColorPicker().transition(onboardingRouter.transition)
            case .mapData:
                DataMapping().transition(onboardingRouter.transition)
            case .lastSteps:
                LastSteps().transition(onboardingRouter.transition)
            }
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
            .environmentObject(OnboardingRouter())
    }
}
