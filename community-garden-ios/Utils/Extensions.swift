//
//  Helpers.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/8/21.
//

import Foundation
import SwiftUI

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}

extension View {
    func fullBackground(imageName: String) -> some View {
        return self.background (
            Image(imageName)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

extension EnvironmentValues {
    var isPreview: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        return false
        #endif
    }
}
