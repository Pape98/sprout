//
//  Entries.swift
//  PersonalStatusWidgetExtension
//
//  Created by Pape Sow Traoré on 30/10/2022.
//

import WidgetKit

struct ProgressEntry: TimelineEntry {
    let date: Date
    let progress: [Float]
    let lastUpdate: Float
}

struct CommunityEntry: TimelineEntry {
    let date: Date
}
