import SwiftUI
import WidgetKit
import Firebase
import FirebaseFunctions
import FirebaseFirestore

struct CommunityWidgetProvider: TimelineProvider {
    
    var firebase: FirebaseHelper
    
    init(){
//        FirebaseApp.configure()
//   
//        if Platform.isSimulator {
//            // Local firestore
//            let settings = Firestore.firestore().settings
//            settings.host = "localhost:8080"
//            settings.isPersistenceEnabled = false
//            settings.isSSLEnabled = false
//            Firestore.firestore().settings = settings
//            
//            // Cloud Functions
//            Functions.functions().useEmulator(withHost: "http://localhost", port:5001)
//        }
        firebase = FirebaseHelper()
    }
    
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
            var progress = await firebase.getGroupProgress()
            progress = progress < 0 ? 0 : progress
            
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
    
    var accentColor: Color {
        let progress = Float(entry.progress) / 100.0
        
        if 0...24 ~= progress {
            return Color("sad-color")
        } else if 25...50 ~= progress {
            return Color("meh-color")
        } else if 51...99 ~= progress {
            print("here")
            return Color("content-color")
        } else {
            return Color("happy-color")
        }
    }
    
    var face: String {
        let progress = Float(entry.progress) / 100.0
        
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
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            Color("background")
            
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Image(systemName: "target")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12)
                        .foregroundColor(accentColor)
                    
                    Text("Community")
                        .font(.custom("Baloo2-Regular", size: 12))
                    
                    Spacer()
                    
                    Image(face)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22.5, height: 22.5)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(entry.progress)%")
                        .font(.custom("Baloo2-Bold", size: 35))
                    
                    ProgressView(value: Float(entry.progress) / 100.0)
                        .tint(accentColor)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .scaleEffect(x: 1, y: 2.25, anchor: .center)
                    
                }
                .padding(.bottom)
                
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

