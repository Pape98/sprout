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
    
    func remove(key: String){
        defaults.removeObject(forKey: key)
    }
    
    func remove(key: UserDefaultsKey){
        defaults.removeObject(forKey: key.rawValue)
    }
    
    func save<T>(value: T, key: UserDefaultsKey){
        defaults.set(value, forKey: key.rawValue)
    }
    
    func save<T>(value: T, key: String){
        defaults.set(value, forKey: key)
    }
    
    func get(key: UserDefaultsKey) -> String? {
        guard let value = defaults.string(forKey: key.rawValue) else { return nil }
        return value
    }
    
    func get(key: UserDefaultsKey) -> [String]? {
        guard let array = defaults.stringArray(forKey: key.rawValue) else { return nil }
        return array
    }
    
    func get(key: UserDefaultsKey) -> Float? {
       return defaults.float(forKey: key.rawValue)
    }
    
    func get(key: UserDefaultsKey) -> [String: Any]? {
        guard let dictionary = defaults.dictionary(forKey: key.rawValue) else { return nil }
        return dictionary
    }
    
    func get(key: UserDefaultsKey) -> Bool? {
        return defaults.bool(forKey: key.rawValue)
    }
    
    func get(key: UserDefaultsKey) -> Data? {
        return defaults.data(forKey: key.rawValue)
    }
    
    func get(key: String) -> Int? {
        return defaults.integer(forKey: key)
    }
}

enum UserDefaultsKey: String {
    case FCM_TOKEN = "fcmToken"
    case IS_MUSIC_ON = "isMusicOn"
    case NUM_LOVE_SENT = "loveSent"
    case NUM_ENCOURAGEMENT_SENT = "encouragementSent"
    case BACKGROUND_MUSIC = "backgroundMusic"
}



