//
//  RemoteConfiguration.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/09/2022.
//

import Foundation
import FirebaseRemoteConfig

class RemoteConfiguration {
    static let shared = RemoteConfiguration()
    
    let config = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    
    init(){
        // FIXME: Remove this before we go into production
        settings.minimumFetchInterval = 10
        config.configSettings = settings
        setupConfigDefaults()
        fetchRemoteConfig()
    }
    
    func setupConfigDefaults(){
        
        let defaultValues = [
            "group0" : ["isSocial": true, "canCustomize": true] as NSObject,
        ]
        
        config.setDefaults(defaultValues)
    }
    
    func fetchRemoteConfig() {
        
        config.fetchAndActivate { status, error in
            guard error == nil else {
                print("Uh-oh. Got an error fetching remote values: \(String(describing: error))")
                return
            }
        }
    }
    
    func getGroupConfig(_ group: String) -> NSDictionary? {
        let json = config.configValue(forKey: group).jsonValue
        guard let json  = json else { return nil }
        let dict = json as! NSDictionary
        return dict
    }
    
    func isSocialConfig(group: Int) -> Bool {
        let dict = getGroupConfig("group\(group)")
        guard let dict = dict else { return false }
        return dict["isSocial"]! as! Bool
    }
    
    func canCustomize(group: Int) -> Bool {
        let dict = getGroupConfig("group\(group)")
        guard let dict = dict else { return false }
        return dict["canCustomize"]! as! Bool
    }
}

enum RemoteConfigKeys: String {
    case thresholdsPercentages, maxNumDroplets, maNumxSeeds
}
