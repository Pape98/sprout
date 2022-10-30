//
//  PersonalStatusWidget.swift
//  PersonalStatusWidget
//
//  Created by Pape Sow Traoré on 29/10/2022.
//

import WidgetKit
import SwiftUI
import SwiftDate

struct Provider: TimelineProvider {
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
        for minuteOffset in [0,15,30,45,60] {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = ProgressEntry(date: entryDate, progress: Array(progress.values), lastUpdate: lastUpdate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct ProgressEntry: TimelineEntry {
    let date: Date
    let progress: [Float]
    let lastUpdate: Float
}

struct PersonalStatusWidgetEntryView : View {
        
    var entry: Provider.Entry

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
        var count = 0
        let progress = entry.progress
        
        if (progress.count == 2) {
            if (progress[1] == 1) { count += 1}
        }
        
        if (progress.count >= 1) {
            if entry.progress[0] == 1 { count += 1}
        }
        
        return count
    }
    
    var lastUpdateHourText: String {
        let now = Float(Date().millisecondsSince1970)
        let difference = now - entry.lastUpdate
        
        if entry.lastUpdate == 0 {
            return "Nothing 😢"
        }
        
        let days = Int(difference / (24 * 60 * 60 * 1000))
        
        if(Int(days) != 0) { return "\(days) day(s) ago 😔" }
        
        let hours = Int(difference / (60 * 60 * 1000))
        if(Int(hours) != 0 && Int(hours) < 24) { return "\(hours) hr(s) ago 🙂" }
        
        let minutes = Int(difference / (60 * 1000))
        
        return "\(minutes) min(s) ago 😊"
            
    }
    
    var body: some View {
 
            ZStack {
               ContainerRelativeShape()
                    .fill(Color("dark-bg"))
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: 0) {
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.green)
                            Text(lastUpdateHourText)
                                .foregroundColor(.white)
                                .opacity(0.9)
                                .font(.custom("Baloo2-regular", size: 12))
                        }

                        Text("\(completedGoals)/2")
                            .foregroundColor(.white)
                            .font(.custom("Baloo2-medium", size: 40))
                    }.padding(.top)

                    Spacer()
                 
                    
                    HStack {
                        Image(face1)
                            .resizable()
                            .scaledToFit()
                        Image(face2)
                            .resizable()
                            .scaledToFit()
                    }
                    .padding(.horizontal)
                    .offset(y: 10)
             
                }
            
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

@main
struct PersonalStatusWidget: Widget {
    let kind: String = "PersonalStatusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PersonalStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Sprout Progress Widget")
        .description("This shows your progress towards your 2 goals.")
        .supportedFamilies([.systemSmall])
    }
}

struct PersonalStatusWidget_Previews: PreviewProvider {
    static var previews: some View {
        PersonalStatusWidgetEntryView(entry: ProgressEntry(date: Date(), progress:[0,1], lastUpdate: Float((Date() - 3.hours).millisecondsSince1970)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
