//
//  AudioPlayer.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/08/2022.
//

import AVFoundation

class AudioPlayer {
    
    static let shared = AudioPlayer()
    var soundEffect: AVAudioPlayer?
    var audioPlayer: AVAudioPlayer?
    
    var backgroundSongs = ["summer_bar",
                           "winter_glade_evening",
                           "autumn_town_day",
                           "slightly_sour",
                           "spring_hamlet_evening"]
    
    func playCustomSound(filename: String, volume: Float = 1){
        let path = Bundle.main.path(forResource: filename, ofType:nil)
        
        guard let path = path else {
            print("Audio file \(filename) does not exist")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
            soundEffect?.volume = volume
        } catch {
            // couldn't load file :(
            print("Could not load \(filename) sound effect: \(error)")
        }
    }
    
    func startBackgroundMusic(){
        let song = backgroundSongs[(Int.random(in: 0..<5))]
        if let bundle = Bundle.main.path(forResource: song, ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.volume = 0.05
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stopBackgroundMusic(){
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
        }
    }
    
    func playSystemSound(soundID: UInt32){
        AudioServicesPlaySystemSound(soundID)
    }
    
}
