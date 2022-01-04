//
//  MoodViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/4/22.
//

import Foundation
import FirebaseAuth

class MoodViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var moods:[Mood] = [Mood]()
    let moodRepository: MoodRepository = MoodRepository.shared
    
    // To access and edit loggedInUser
    var currentUser: User = UserService.shared.user
    
    // MARK: Methods
    
    init() {
        getCurrentUserMoodEntries()
    }
    
    func getCurrentUserMoodEntries() {
        moodRepository.getMoodEntries(userId: currentUser.id) { result in
            DispatchQueue.main.async {
                self.moods = result
            }
        }
    }
    
    func addMood(moodType: String, date: Date) {
        
        let newMood = Mood(id: UUID().uuidString,
                           text: moodType,
                           date: date,
                           userId: currentUser.id)
        
        moodRepository.addMood(newMood) { () in
            
            self.getCurrentUserMoodEntries()
        }
    }

    
    
}
