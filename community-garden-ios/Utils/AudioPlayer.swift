//
//  AudioPlayer.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/08/2022.
//

import AVFoundation

class AudioPlayer {
    
    static var soundEffect: AVAudioPlayer?
    
    static func playSound(filename: String){
        let path = Bundle.main.path(forResource: filename, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        } catch {
            // couldn't load file :(
            print("Could load \(filename) sound effect")
        }
    }
    
}
