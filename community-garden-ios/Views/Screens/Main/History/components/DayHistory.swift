//
//  DayHistory.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 10/31/22.
//

import SwiftUI
import SpriteKit
import SwiftDate

struct DayHistory: View {
    
    @ObservedObject var dataHistoryViewModel: DataHistoryViewModel = DataHistoryViewModel.shared
    
    var scene: SKScene {
        let scene = GardenHistoryScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var date: String
    
    var formattedDate: String {
        let region = Region(zone: Zones.americaNewYork)
        let date = DateInRegion(date, region: region)!.date.getFormattedDate(format: "MMM d, yyyy")
        return date
    }
    
    var body: some View {
        ZStack {
            // MARK: SpriteKit view
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea(.container, edges:[.top])
                .weatherOverlay()
                .onAppear {
                    // SproutAnalytics.shared.viewOwnGarden()
                    dataHistoryViewModel.getUserItemsByDate(date: date)
                }
                .onDisappear {
                    dataHistoryViewModel.historyItems = []
                }
                .navigationTitle(formattedDate)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DayHistory_Previews: PreviewProvider {
    static var previews: some View {
        DayHistory(date: "10-31-2022")
    }
}
