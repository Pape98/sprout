//
//  AppGroupService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 29/10/2022.
//

import Foundation

class AppGroupService {
    
    static let shared = AppGroupService()
    var defaults: UserDefaults
    
    init(){
        defaults = UserDefaults(suiteName: "group.empower.lab.community-garden")!
    }
    
    func save<T>(value: T, key: AppGroupKey){
        defaults.set(value, forKey: key.rawValue)
        defaults.set(Date().millisecondsSince1970, forKey: AppGroupKey.lastUpdate.rawValue)
    }
    
    
    func get(key: AppGroupKey) -> Float {
       return defaults.float(forKey: key.rawValue)
    }
    
    func get(key: AppGroupKey) -> [String:Float] {
        return defaults.object(forKey: key.rawValue) as? [String:Float] ?? [:]
    }
}

enum AppGroupKey: String {
    case lastUpdate = "lastUpdate"
    case progressData = "progressData"
}

extension Date {
    var millisecondsSince1970: Int64 {
           Int64((self.timeIntervalSince1970 * 1000.0).rounded())
       }
       
       init(milliseconds: Int64) {
           self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
       }
}
