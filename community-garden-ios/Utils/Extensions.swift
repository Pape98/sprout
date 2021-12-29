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
                .resizable()
                .aspectRatio(UIImage(named: imageName)!.size, contentMode: .fill)
                .edgesIgnoringSafeArea(.top)
        )
    }
}
