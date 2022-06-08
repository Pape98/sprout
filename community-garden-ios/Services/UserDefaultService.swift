//
//  UserDefaultService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 08/06/2022.
//

import Foundation

enum SettingsKey: String {
    case TREE = "tree"
}

class UserDefaultsService {
    
    let defaults = UserDefaults.standard
    static let shared = UserDefaultsService()
    
    func save<T>(value: T, key: SettingsKey){
        defaults.set(value, forKey: key.rawValue)
    }
    
    func getString(key: SettingsKey) -> String? {
        guard let value = defaults.string(forKey: key.rawValue) else { return nil }
        return value
    }
}


