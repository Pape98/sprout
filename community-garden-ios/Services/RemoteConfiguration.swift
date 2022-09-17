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
            RemoteConfigKeys.maxNumDroplets.rawValue: 50 as NSObject,
            RemoteConfigKeys.maNumxSeeds.rawValue: 20 as NSObject
        ]
        
        config.setDefaults(defaultValues)
    }
    
    func fetchRemoteConfig() {
        config.fetch(withExpirationDuration: 0) { status, error in
            guard error == nil else {
                print("Uh-oh. Got an error fetching remote values: \(String(describing: error))")
                return
            }
            self.config.activate()
        }
    }
}

enum RemoteConfigKeys: String {
    case thresholdsPercentages, maxNumDroplets, maNumxSeeds
}
