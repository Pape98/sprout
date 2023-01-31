//
//  Platform.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 30/10/2022.
//

import Foundation

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
