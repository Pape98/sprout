//
//  UserDefaultService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 08/06/2022.
//

import Foundation

enum UserDefaultsKey: String {
    case TREE = "tree"
    case FLOWER = "flower"
}

class UserDefaultsService {
    
    let defaults = UserDefaults.standard
    static let shared = UserDefaultsService()
    
    func save<T>(value: T, key: UserDefaultsKey){
        defaults.set(value, forKey: key.rawValue)
    }
    
    func getString(key: UserDefaultsKey) -> String? {
        guard let value = defaults.string(forKey: key.rawValue) else { return nil }
        return value
    }
}


