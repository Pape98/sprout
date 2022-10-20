//
//  AudioPlayer.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/08/2022.
//

import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate  {
    
    static let shared = AudioPlayer()
    var soundEffect: AVAudioPlayer?
    var audioPlayer: AVAudioPlayer?
    
    var backgroundSongs = ["slightly_sour",
                           "summer_bar",
                           "winter_glade_evening",
                           "autumn_town_day",
                           "spring_hamlet_evening"]
    
    var currentSongIndex = 0
    let userDefaults = UserDefaultsService.shared
    
    override init(){
        if AppViewModel.shared.isBadgeUnlocked(UnlockableBadge.music) == true {
            backgroundSongs = backgroundSongs.shuffled()
        }
    }
    
    func playCustomSound(filename: String, volume: Float = 1){
        let path = Bundle.main.path(forResource: filename, ofType:"mp3")
        
        guard let path = path else {
            Debug.log.error("Audio file \(filename) does not exist")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
            soundEffect?.volume = volume
        } catch {
            // couldn't load file :(
            Debug.log.error("Could not load \(filename) sound effect: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        startBackgroundMusic()
    }
    
    func startBackgroundMusic(){
        
        guard isUserLoggedIn() == true else { return }
        let isMusicOn: Bool? = userDefaults.get(key: UserDefaultsKey.IS_MUSIC_ON)
        Debug.log.debug(isMusicOn)

        
        guard isMusicOn != nil && isMusicOn! == true else { return }
        
        changeSong()
        let song = backgroundSongs[currentSongIndex]
        if let bundle = Bundle.main.path(forResource: song, ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = 0
                audioPlayer.delegate = self
                audioPlayer.volume = 0.05
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                Debug.log.error(error)
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
    
    func changeSong(){
        if AppViewModel.shared.isBadgeUnlocked(UnlockableBadge.music) == false {
            currentSongIndex = 0
            return
        }
        
        if currentSongIndex == backgroundSongs.endIndex{
            currentSongIndex = 0
        }
    }
}
