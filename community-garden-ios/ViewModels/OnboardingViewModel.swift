//
//  OnboardingViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 28/06/2022.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    
    static let shared = OnboardingViewModel()
    @Published var isNewUser: OnboardingStatus = OnboardingStatus.NEW_USER
    
    init(){
        let isNewUserString: String? = UserDefaultsService.shared.get(key: UserDefaultsKey.IS_NEW_USER)
        if let isNewUserString = isNewUserString {
            isNewUser = OnboardingStatus(rawValue: isNewUserString)!
        }
    }
}

enum OnboardingStatus: String {
    case NEW_USER
    case EXISITING_USER
}
