//
//  OnboardingRouter.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/06/2022.
//

import Foundation
import SwiftUI

class OnboardingRouter: ObservableObject {
    
    @Published var currentScreen: Screen = .chooseData
    @Published var transition: AnyTransition = .slide
    var settings: [String: Any] = [:]
    
    let nextScreens : [Screen: Screen] = [.chooseData: .setGoals,
                                          .setGoals: .chooseTree,
                                          .chooseTree: .chooseTreeColor,
                                          .chooseTreeColor: .chooseFlower,
                                          .chooseFlower: .chooseFlowerColor,
                                          .chooseFlowerColor: .mapData,
                                          .mapData: .lastSteps,
                                          .lastSteps: .lastSteps]
    
    let backScreens : [Screen: Screen] = [.setGoals: .chooseData,
                                          .chooseTree: .setGoals,
                                          .chooseTreeColor: .chooseTree,
                                          .chooseFlower: .chooseTreeColor,
                                          .chooseFlowerColor: .chooseFlower,
                                          .mapData: .chooseFlowerColor,
                                          .lastSteps: .mapData]
    
    
    static let shared = OnboardingRouter()
    
    func saveSetting(key: FirestoreKey, value: Any){
        settings[key.rawValue] = value
    }
    
    func getSetting(key: FirestoreKey) -> Any? {
        return settings[key.rawValue]
    }
    
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
