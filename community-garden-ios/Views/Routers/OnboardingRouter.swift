//
//  OnboardingRouter.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/06/2022.
//

import Foundation
import SwiftUI

class OnboardingRouter: ObservableObject {
    
    @Published var currentScreen: Screen = .chooseFlower
    @Published var transition: AnyTransition = .slide
    
    let nextScreens : [Screen: Screen] = [.chooseData: .mapData,
                                          .mapData: .chooseTree,
                                          .chooseTree: .chooseTreeColor,
                                          .chooseTreeColor: .chooseFlower,
                                          .chooseFlower: .chooseFlowerColor,
                                          .chooseFlowerColor: .chooseData]
    
    let backScreens : [Screen: Screen] = [.mapData: .chooseData,
                                          .chooseTree: .mapData,
                                          .chooseTreeColor: .chooseTree,
                                          .chooseFlower: .chooseTreeColor,
                                          .chooseFlowerColor: .chooseFlower]
    
    
    static let shared = OnboardingRouter()
    
    func setScreen(_ newScreen: Screen){
        currentScreen = newScreen
    }
    
    func navigateNext() {
        setScreen(nextScreens[currentScreen]!)
    }
    
    func navigateBack() {
        setScreen(backScreens[currentScreen]!)
    }
    
    func setTransition(_ newTransition: AnyTransition){
        transition = newTransition
    }
}
