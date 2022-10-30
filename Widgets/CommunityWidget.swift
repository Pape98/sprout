import SwiftUI
import WidgetKit

struct CommunityWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> CommunityEntry {
        CommunityEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CommunityEntry) -> Void) {
        let entry = CommunityEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [CommunityEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in [0,15,30] {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = CommunityEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CommunityWidgetEntryView: View {
    var entry: CommunityWidgetProvider.Entry
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color("background")
                
                VStack(alignment: .leading) {
                    HStack(spacing: 5) {
                        Image(systemName: "globe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                            .foregroundColor(Color("content-color"))
                        
                        Text("Community")
                            .font(.custom("Baloo2-Regular", size: 12))
                        
                        Spacer()
                        
                        Image("faces/content")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22.5, height: 22.5)

                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("50%")
                            .font(.custom("Baloo2-Bold", size: 35))
                        
                        ProgressView(value: 0.5)
                            .tint(Color("content-color"))
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                            .scaleEffect(x: 1, y: 2.25, anchor: .center)
                        Text("3 hr(s) ago")
                            .font(.custom("Baloo2-Regular", size: 12))
                    }
                    
                }
                .padding()
                
            }
            .foregroundColor(Color("font-color"))
        }
    }
    
}

struct CommunityWidget: Widget {
    let kind: String = "CommunityWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CommunityWidgetProvider()) { entry in
            CommunityWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Community Progress Widget")
        .description("This shows the current day's progress of your community")
        .supportedFamilies([.systemSmall])
    }
}

struct CommunityWidget_Previews: PreviewProvider {
    static var previews: some View {
        CommunityWidgetEntryView(entry: CommunityEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

