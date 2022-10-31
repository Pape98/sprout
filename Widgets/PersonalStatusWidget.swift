//
//  PersonalStatusWidget.swift
//  PersonalStatusWidget
//
//  Created by Pape Sow Traoré on 29/10/2022.
//

import WidgetKit
import SwiftUI
import SwiftDate

struct PersonalStatusProvider: TimelineProvider {
    func placeholder(in context: Context) -> ProgressEntry {
        ProgressEntry(date: Date(), progress:[0,0], lastUpdate: Float((Date() - 3.hours).millisecondsSince1970))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ProgressEntry) -> ()) {
        let progress: [String: Float] = AppGroupService.shared.get(key: AppGroupKey.progressData)
        let lastUpdate: Float = AppGroupService.shared.get(key: AppGroupKey.lastUpdate)
        let entry = ProgressEntry(date: Date(), progress:Array(progress.values), lastUpdate: lastUpdate)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let progress: [String: Float] = AppGroupService.shared.get(key: AppGroupKey.progressData)
        let lastUpdate: Float = AppGroupService.shared.get(key: AppGroupKey.lastUpdate)
        
        var entries: [ProgressEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in [0,15,30] {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = ProgressEntry(date: entryDate, progress: Array(progress.values), lastUpdate: lastUpdate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct PersonalStatusWidgetEntryView : View {
    
    var entry: PersonalStatusProvider.Entry
    
    var face1: String {
        let progress = entry.progress
        if progress.count == 0 || isToday(time: entry.lastUpdate) == false { return "faces/sad"}
        return returnFace(progress: progress[0] * 100)
    }
    
    var face2: String {
        let progress = entry.progress
        if progress.count < 2 || isToday(time: entry.lastUpdate) == false{ return "faces/sad"}
        return returnFace(progress: progress[1] * 100)
    }
    
    var completedGoals: Int {
        if isToday(time: entry.lastUpdate) == false { return 0 }
        print(entry)

        var count = 0
        let progress = entry.progress
        
        if (progress.count == 2) {
            if (progress[1] >= 1) { count += 1}
        }
        
        if (progress.count >= 1) {
            if progress[0] >= 1 { count += 1}
        }
        
        return count
    }
    
    var lastUpdateHourText: String {
        let now = Float(Date().millisecondsSince1970)
        let difference = now - entry.lastUpdate
        
        if entry.lastUpdate == 0 {
            return "Nothing"
        }
        
        let days = Int(difference / (24 * 60 * 60 * 1000))
        
        if(Int(days) != 0) { return "\(days) day(s) ago" }
        
        let hours = Int(difference / (60 * 60 * 1000))
        if(Int(hours) != 0 && Int(hours) < 24) { return "\(hours) hr(s) ago" }
        
        let minutes = Int(difference / (60 * 1000))
        
        return "\(minutes) min(s) ago"
        
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            ContainerRelativeShape()
                .fill(Color("background"))
            
            VStack(spacing: 0) {
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12)
                        .foregroundColor(Color("apple-green"))
                    
                    Text(lastUpdateHourText)
                        .foregroundColor(Color("font-color"))
                        .opacity(0.9)
                        .font(.custom("Baloo2-Medium", size: 11))
                }
                
                Text("\(completedGoals)/2")
                    .foregroundColor(Color("font-color"))
                    .font(.custom("Baloo2-Bold", size: 35))
                
                HStack {
                    Image(face1)
                        .resizable()
                        .scaledToFit()
                    Image(face2)
                        .resizable()
                        .scaledToFit()
                }
                .offset(y: 5)
                
            }
            .padding(.top)
        }
    }
    
    func returnFace(progress: Float) -> String {
        
        if 0...24 ~= progress {
            return "faces/sad"
        } else if 25...50 ~= progress {
            return "faces/meh"
        } else if 51...99 ~= progress {
            return "faces/content"
        } else {
            return "faces/happy"
        }
    }
    
    func isToday(time: Float) -> Bool {
        return (Date(milliseconds: Int64(time))).compare(.isToday)
    }
}

struct PersonalStatusWidget: Widget {
    let kind: String = "PersonalStatusWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PersonalStatusProvider()) { entry in
            PersonalStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Progress Widget")
        .description("See how many goals you have achieved today.")
        .supportedFamilies([.systemSmall])
    }
}


struct PersonalStatusWidget_Previews: PreviewProvider {
    static var previews: some View {
        PersonalStatusWidgetEntryView(entry: ProgressEntry(date: Date(), progress:[0,1], lastUpdate: Float((Date() - 3.hours).millisecondsSince1970)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
