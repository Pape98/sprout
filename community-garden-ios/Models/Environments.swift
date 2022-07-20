//
//  Environments.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 15/06/2022.
//

import Foundation
import SwiftUI

struct DataString: EnvironmentKey {
    static let defaultValue: String = ""
}

struct DataList: EnvironmentKey {
    static let defaultValue: [Any] = []
}

