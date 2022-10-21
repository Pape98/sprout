//
//  MusicList.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/10/2022.
//

import SwiftUI

struct MusicList: View {
    
    @State var currentSong = ""
    let audioPlayer = AudioPlayer()
    
    var body: some View {
        ZStack {
            MainBackground()
            
            VStack(spacing: 0) {
                Text("Tap on name to listen to song")
                    .bodyStyle()
                List {
                    ForEach(AudioPlayer.shared.backgroundSongs.sorted(), id: \.self){ song in
                        HStack {
                            Image(systemName: "music.note")
                            Text(formatSong(song))
                            Spacer()
                            if song == currentSong {
                                Image("faces/content")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            currentSong = song
                            audioPlayer.playCustomSound(filename: song, volume: 0.05)
                        }
                    }
                }
                .modifier(ListBackgroundModifier())
            }
        }
        .onAppear {
            AudioPlayer.shared.stopBackgroundMusic()
        }
        .onDisappear {
            AudioPlayer.shared.changeSong()
            AudioPlayer.shared.startBackgroundMusic()
        }
        .navigationTitle("List of Songs")
    }
    
    func formatSong(_ song: String) -> String {
        let words = song.split(separator: "_")
        let capitalizedWords = words.map { $0.capitalized }
        return capitalizedWords.joined(separator: " ")
    }
}

struct MusicList_Previews: PreviewProvider {
    static var previews: some View {
        MusicList()
    }
}
