import SwiftUI
import WidgetKit

struct CommunityWidgetProvider: TimelineProvider {
    
    var firebase = FirebaseHelper.shared
    
    func placeholder(in context: Context) -> CommunityEntry {
        CommunityEntry(date: Date(), progress: 50)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CommunityEntry) -> Void) {
        Task {
            let progress = await firebase.getGroupProgress()
            let entry = CommunityEntry(date: Date(), progress: progress)
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        
        Task {
            var entries: [CommunityEntry] = []
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            let progress = await firebase.getGroupProgress()
            
            for minuteOffset in [0,10] {
                let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                let entry = CommunityEntry(date: entryDate, progress: progress)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct CommunityWidgetEntryView: View {
    var entry: CommunityWidgetProvider.Entry
    
    var lastUpdateTimeText: String {
        let now = Date().millisecondsSince1970
        let difference = now - entry.date.millisecondsSince1970
        
        let minutes = Int(difference / (60 * 1000))
        return "\(minutes) min(s) ago"
    }
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            Color("background")
            
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Image(systemName: "target")
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
                    Text("\(entry.progress)%")
                        .font(.custom("Baloo2-Bold", size: 35))
                    
                    ProgressView(value: Float(entry.progress) / 100.0)
                        .tint(Color("content-color"))
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .scaleEffect(x: 1, y: 2.25, anchor: .center)
                    Text(lastUpdateTimeText)
                        .font(.custom("Baloo2-Regular", size: 12))
                }
                
            }
            .padding()
            
        }
        .foregroundColor(Color("font-color"))
    }
    
    
}

struct CommunityWidget: Widget {
    let kind: String = "CommunityWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CommunityWidgetProvider()) { entry in
            CommunityWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Community Widget")
        .description("See how your commnity is doing.")
        .supportedFamilies([.systemSmall])
    }
}

struct CommunityWidget_Previews: PreviewProvider {
    static var previews: some View {
        CommunityWidgetEntryView(entry: CommunityEntry(date: Date(), progress: 50))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

