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
    
    var data: HealthData
    
    var formattedDate: String {
        let region = Region(zone: Zones.americaNewYork)
        let date = DateInRegion(data.date, region: region)!.date.getFormattedDate(format: "MMM d, yyyy")
        return date
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {
                // MARK: SpriteKit view
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .ignoresSafeArea(.container, edges:[.top])
                    .weatherOverlay()
                    .onAppear {
                        // SproutAnalytics.shared.viewOwnGarden()
                        dataHistoryViewModel.getUserItemsByDate(date: data.date)
                    }
                    .onDisappear {
                        dataHistoryViewModel.historyItems = []
                    }
                    .navigationTitle(formattedDate)
                    .navigationBarTitleDisplayMode(.inline)
                
                // MARK: Card
                
                HistoryCard(data: data)
                    .padding()
                    .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.3)
            }
        }
    }
}

struct DayHistory_Previews: PreviewProvider {
    static let data = Step(date: "", count: 5458, userID: "", goal: 10000, username:"", group: 0)

    static var previews: some View {
        DayHistory(data: data)
            .environmentObject(AppViewModel())
    }
}
