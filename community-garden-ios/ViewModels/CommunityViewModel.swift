//
//  CommunityViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 18/09/2022.
//

import Foundation
import SwiftDate
import SwiftUI

class CommunityViewModel: ObservableObject {
    static let shared = CommunityViewModel()
    
    let gardenRepository = GardenRepository.shared
    let userRepository = UserRepository.shared
    let groupRepository = GroupRepository.shared
    let reactionRepository = ReactioRepository.shared
    let goalsRepositiry = GoalsRepository.shared
    let userDefaults = UserDefaultsService.shared
    
    let collections = Collections.shared
    let nc = NotificationCenter.default
    
    @Published var members: [String: User] = [:]
    @Published var trees: [GardenItem] = []
    @Published var group: GardenGroup? = nil
    @Published var reactions: Reactions? = nil
    @Published var goalsStat: GoalsStat? = nil
    
    let MAX_NUM_MESSAGES = 3
    
    @Published var showToast = false
    var toastTitle = ""
    var toastImage = ""
    var toastColor: Color = .red
    
    init(){
        refreshCommunity()
        nc.addObserver(self,
                       selector: #selector(self.fetchTrees),
                       name: Notification.Name(NotificationType.FetchCommunityTrees.rawValue),
                       object: nil)
        
        nc.addObserver(self,
                       selector: #selector(self.getGoalCompletions),
                       name: Notification.Name(NotificationType.FetchGoalStat.rawValue),
                       object: nil)
        
        getGoalCompletions()
        
        DispatchQueue.main.async {
            self.reactions = Reactions(group: UserService.shared.user.group, date: Date.today, love: 0)
        }
    }
    
    func refreshCommunity(){
        fetchTrees()
        fetchGroupMembers()
        fetchGroup()
        fetchReactions()
    }
    
    @objc func getGoalCompletions(){
        goalsRepositiry.getGoalsStatByDate(date: Date.today) { result in
            self.goalsStat = result
        }
    }
    
    func fetchGroup(){
        let groupNumber = UserService.shared.user.group
        
        groupRepository.fetchGroup(groupNumber: groupNumber) { group in
            DispatchQueue.main.async {
                self.group = group
            }
        }
    }
    
    func fetchGroupMembers(){
        let userGroup = UserService.shared.user.group
        let userID = getUserID()
        guard let userID = userID else { return }
        
        let collection = self.collections.getCollectionReference(CollectionName.users.rawValue)
        guard let collection = collection else { return }
        
        let query = collection.whereField("group", isEqualTo: userGroup)
            .whereField("id", isNotEqualTo: userID)
        
        userRepository.fetchAllUsers(query: query) { users in
            var temp: [String: User] = [:]
            
            for user in users {
                temp[user.id] = user
            }
            
            DispatchQueue.main.async {
                self.members = temp
            }
        }
    }
    
    @objc func fetchTrees(){
        let userGroup = UserService.shared.user.group
        let collection = self.collections.getCollectionReference(CollectionName.gardenItems.rawValue)
        guard let collection = collection else { return }
        let query = collection.whereField("date", isEqualTo: Date.today)
            .whereField("group", isEqualTo: userGroup)
            .whereField("type", isEqualTo: GardenItemType.tree.rawValue)
        
        
        gardenRepository.getUserItems(query: query) { trees in
            DispatchQueue.main.async {
                self.trees = trees
            }
        }
    }
    
    func fetchReactions(){
        reactionRepository.fetchReactions { result in
            DispatchQueue.main.async {
                self.reactions = result
            }
        }
    }
    
    func sendLove(){
        
        let todayKey = todayDefaultKey(defaultKey: UserDefaultsKey.NUM_LOVE_SENT)
        let yesterdayKey = yesterdayDefaultKey(defaultKey: UserDefaultsKey.NUM_LOVE_SENT)
        let numLoveSent: Int? = userDefaults.get(key: todayKey)
        
        if numLoveSent == nil {
            userDefaults.save(value: 1, key: todayKey)
            userDefaults.remove(key: yesterdayKey)
        }  else if numLoveSent! >= MAX_NUM_MESSAGES {
            setToast(title: "Can only send \(MAX_NUM_MESSAGES) per day", image: "xmark.octagon.fill", color: .red)
            showToast = true
            return
        } else {
            userDefaults.save(value: numLoveSent! + 1, key: todayKey)
        }
        
        setToast(title: "Sent love to 🧑‍🤝‍🧑", image: "heart.fill", color: .red)
        showToast = true
        
        let tokens: [String] = members.values.map { $0.fcmToken }
        reactionRepository.increaseReactionCount(reaction: ReactionType.love, tokens: tokens){
            self.fetchReactions()
            let user = UserService.shared.user
            SproutAnalytics.shared.groupMessage(senderID: user.id, senderName: user.name, type: ReactionType.love)
        }
        
    }
    
    func sendEncouragement(){
        
        let todayKey = todayDefaultKey(defaultKey: UserDefaultsKey.NUM_ENCOURAGEMENT_SENT)
        let yesterdayKey = yesterdayDefaultKey(defaultKey: UserDefaultsKey.NUM_ENCOURAGEMENT_SENT)
        let numEncouragementSent: Int? = userDefaults.get(key: todayKey)
        
        if numEncouragementSent == nil {
            userDefaults.save(value: 1, key: todayKey)
            userDefaults.remove(key: yesterdayKey)
        }  else if numEncouragementSent! >= MAX_NUM_MESSAGES {
            setToast(title: "Can only send \(MAX_NUM_MESSAGES) per day", image: "xmark.octagon.fill", color: .red)
            showToast = true
            return
        } else {
            userDefaults.save(value: numEncouragementSent! + 1, key: todayKey)
        }
        
        setToast(title: "Sent cheers to 🧑‍🤝‍🧑", image:  "star.fill", color: .yellow)
        showToast = true
        
        let tokens: [String] = members.values.map { $0.fcmToken }
        reactionRepository.increaseReactionCount(reaction: ReactionType.encouragement, tokens: tokens){
            self.fetchReactions()
            let user = UserService.shared.user
            SproutAnalytics.shared.groupMessage(senderID: user.id, senderName: user.name, type: ReactionType.encouragement)
            self.showToast = true
        }
    }
    
    // helpers
    func setToast(title: String, image: String, color: Color){
        toastTitle = title
        toastImage = image
        toastColor = color
    }
    
    func todayDefaultKey(defaultKey: UserDefaultsKey) -> String {
        let today = Date()
        let todayKey =  today.toFormat("dd MM yyyy").replacingOccurrences(of: " ", with: "-") + "-" + defaultKey.rawValue
        return todayKey
    }
    
    func yesterdayDefaultKey(defaultKey: UserDefaultsKey) -> String {
        let yesterday = Date() - 1.days
        let yesterdayKey =  yesterday.toFormat("dd MM yyyy").replacingOccurrences(of: " ", with: "-") + "-" + defaultKey.rawValue
        return yesterdayKey
    }
}
