//
//  UserDefaultService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 08/06/2022.
//

import Foundation


class UserDefaultsService {
    
    let defaults = UserDefaults.standard
    static let shared = UserDefaultsService()
    
    func save<T>(value: T, key: UserDefaultsKey){
        defaults.set(value, forKey: key.rawValue)
    }
    
    func get(key: UserDefaultsKey) -> String? {
        guard let value = defaults.string(forKey: key.rawValue) else { return nil }
        return value
    }
    
    func get(key: UserDefaultsKey) -> [String]? {
        guard let array = defaults.stringArray(forKey: key.rawValue) else { return nil }
        return array
    }
    
    func get(key: UserDefaultsKey) -> Float {
       return defaults.float(forKey: key.rawValue)
    }
    
    func get(key: UserDefaultsKey) -> [String: Any]? {
        guard let dictionary = defaults.dictionary(forKey: key.rawValue) else { return nil }
        return dictionary
    }
    
    func get(key: UserDefaultsKey) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }
}

enum UserDefaultsKey: String {
    // Onboarding
    case TREE = "tree"
    case TREE_COLOR = "tree-color"
    case FLOWER = "flower"
    case FLOWER_COLOR = "flower-color"
    case DATA = "data"
    case STEPS_GOAL = "steps-goal"
    case SLEEP_GOAL = "sleep-goal"
    case MAPPED_DATA = "mapped-data"
    case GARDEN_NAME = "garden-name"
    case REFLECT_WEATHER_CHANGES = "reflect-weather-changes"
    case IS_NEW_USER = "is-new-user"
}


