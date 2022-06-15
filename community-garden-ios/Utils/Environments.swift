//
//  Environments.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 15/06/2022.
//

import Foundation
import SwiftUI

struct SettingsKey: EnvironmentKey {
    static let defaultValue: UserDefaultsKey = UserDefaultsKey.TREE
}
