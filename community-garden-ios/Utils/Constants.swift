//
//  Constants.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/4/21.
//

import Foundation
import HealthKit
import SwiftUI

struct Constants {
    
    static let shared = Constants()
    
    static let clientID = "987260271190-lt53tt7akbciedliq2mdno33jpg08eb2.apps.googleusercontent.com"
    
    // Garden Items
    static let flowers = ["abyss-sage", "joyful-clover","savage-morel"]
    static let trees = ["spiky-maple", "whomping-medlar", "serpent-sumac","sad-holly","sneezy-cypress","tickle-beech","royal-larch","chilling-leaf"]
    static let colors = ["moss","cosmos","sunglow","grenadier","hawks","tangerine","lavender","mint","raspberry","porcelain"]
    
    static var badges = [UnlockableBadge.birds: CommunityBadge(name: "birds",
                                                               numberOfDaysRequired: 8,
                                                               description: "Let’s add some birds 🐦to your sky to make it more alive.",
                                                               note: "❗Birds are now freely traveling in your personal and community garden."),
                         
                         UnlockableBadge.cloud: CommunityBadge(name: "cloud",
                                                               numberOfDaysRequired: 1,
                                                               description: "⭐ The sky was really sad 😔. Here are some clouds ☁️to help beautify your sky and make her happy.",
                                                               note: "❗Now both your garden and the community garden have clouds. Go check ☺️."),
                         
                         UnlockableBadge.deer : CommunityBadge(name: "deer",
                                                               numberOfDaysRequired: 6,
                                                               description: "⭐ Here is Bambi the Deer 🦌, Dexter’s bestfriend. She really enjoys walking around the garden.",
                                                               note: "❗Go visit Bambi the Deer 🦌in the community garden."),
                         
                         UnlockableBadge.dogHouse: CommunityBadge(name: "dogHouse",
                                                                  numberOfDaysRequired: 3,
                                                                  description: "⭐ Woohoo!!! You have unblocked Dexter and Daisy’s new doghouses. A message from Dexter and Daisy, “Thank you so much for these wonderful homes 🏠, however we are lonely here. we do not see other animals. Can you help us?",
                                                                  note: "❗Check both your garden 🌼and the community garden to see the doghouses 🏠."),
                         
                         UnlockableBadge.turtleHouse: CommunityBadge(name: "turtleHouse",
                                                                     numberOfDaysRequired: 12,
                                                                     description: "⭐ Woohoo!! Franklin the Turtle 🐢has his own house now 🏠.",
                                                                     note: "❗Go see Franklin’s house 🏠in the community view. His houses are green 🟢."),
                         
                         UnlockableBadge.dog: CommunityBadge(name: "dog",
                                                             numberOfDaysRequired: 2,
                                                             description: "⭐ Look who is here now, this is dexter the Dog 🐕and her sister Daisy 🐕. They are very excited to meet you. However, even though they are loved ❤️, they still do not have a house of their own 😔. Will you be able to help them get a house of their own? Keep unlocking items!",
                                                             note: "❗Go visit the community garden in order to see Dexter the Dog 🐕 and his sister Daisy 🐕."),
                         
                         UnlockableBadge.pond: CommunityBadge(name: "pond",
                                                              numberOfDaysRequired: 5,
                                                              description: "⭐ Dexter the Dog  🐕 and Daisy 🐕have been without water for days 🌊. Here are some ponds they can use to drink.",
                                                              note:"❗Check the ponds 🌊in your community garden."),
                         
                         UnlockableBadge.fence: CommunityBadge(name: "fence",
                                                               numberOfDaysRequired: 7,
                                                               description: "⭐ Here is a fence to protect your garden and flowers from being attacked by wild animals 🐍.",
                                                               note:"❗Check your personal garden to see the fence."),
                         
                         UnlockableBadge.music: CommunityBadge(name: "music",
                                                               numberOfDaysRequired: 4,
                                                               description: "⭐ I am sure you are tired of listening to the same background music 🎵. So, we are offering you 4 new background songs 🎶.",
                                                               note: "❗Go to “settings” > “View list of songs” to listen to other songs 🎵."),
                         
                         UnlockableBadge.turtle: CommunityBadge(name: "turtle",
                                                                numberOfDaysRequired: 10,
                                                                description: "⭐ Here is a Franklin the Turtle 🐢. Just like his friend Dexter the Dog, Franklin does not have a house 🏠of his own. Can you help him too?",
                                                                note:"❗Go visit Franklin 🐢 in the community garden.")
    ]
    
    
    
    static let mainFont = "Baloo2-Medium"
    
    init(){}
}

enum UnlockableBadge {
    case birds, cloud, deer, dogHouse, dog, fence, music, turtle, turtleHouse, pond
}

struct JSON {
    static let encoder = JSONEncoder()
}

enum MappingKeys: String {
    case TREE = "Tree"
    case FLOWER = "Flower"
}

enum GardenElement: String {
    case droplet
    case seed
    case animal
    case tree
    case flower
}

enum DataOptions: String, CaseIterable {
    case steps = "Steps"
    case sleep = "Sleep"
    case walkingRunningDistance = "Walking+running Distance"
    case workouts = "Workout Time"
    
    static var dalatList: [String] {
        return DataOptions.allCases.map { $0.rawValue }
    }
    
    static let icons = ["Steps":["figure.walk","🦶🏻Daily number of steps."],
                        "Sleep":["bed.double.circle","🛌🏽 Amount of time in bed."],
                        "Walking+running Distance":["bed.double.circle","🚶 Distance you walk or run."],
                        "Workout Time": ["bed.double.circle","🚴‍♀️ The number of workout minutes"]
    ]
}

enum Statistics: String, CaseIterable {
    case numDroplets = "numDroplets"
    case numSeeds = "numSeeds"
    
    static var list:[String] {
        Statistics.allCases.map { $0.rawValue}
    }
}

struct GoalsSettings {
    static let ranges: [String: ClosedRange<Float>] = [
        "Steps": 0...20000,
        "Sleep": 0...12,
        "Workout Time": 0...180,
        "Walking+running Distance": 1...20
    ]
    
    static let steps: [String: Float] = [
        "Steps": 500,
        "Sleep": 1,
        "Workout Time": 10,
        "Walking+running Distance": 1
    ]
    
    static let labels = [
        "Steps": "Step(s)",
        "Sleep": "Hour(s)",
        "Workout Time": "Minute(s)" ,
        "Walking+running Distance": "Mile(s)"
    ]
    
    static let titles = [
        "Steps": "Steps 🦶🏻",
        "Sleep": "Sleep 🛌🏽",
        "Workout Time": "Workout Time 🚴‍♀️",
        "Walking+running Distance": "Walking + Running Distance 🚶"
    ]
    
    static let defaultsKeys = [
        "Steps": FirestoreKey.STEPS_GOAL,
        "Sleep": FirestoreKey.SLEEP_GOAL,
        "Workout Time": FirestoreKey.WORKOUT_GOAL,
        "Walking+running Distance": FirestoreKey.WALKING_RUNNING_GOAL
    ]
}

enum SettingsMode: String {
    case treeType
    case flowerType
    case treeColor
    case flowerColor
}







