//
//  MessagesViewModel.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 21/07/2022.
//

import Foundation

class MessagesViewModel: ObservableObject {
    
    static let shared = MessagesViewModel()
    var messageToDelete = ""
    
    @Published var options = [
        MessageOption(text: "Proud of you!", color: "cosmos"),
        MessageOption(text: "You are the best!", color: "sunglow"),
        MessageOption(text: "You are amazing!", color: "lavender"),
        MessageOption(text: "Have a wonderful day!", color: "tangerine"),
        
    ]
    
    func addOption(text: String, color: String){
        let option = MessageOption(text: text, color: color, isDefault: false)
        DispatchQueue.main.async {
            self.options.append(option)
        }
    }
    
    func deleteOption(){
        DispatchQueue.main.async {
            self.options = self.options.filter { $0.text != self.messageToDelete }
            self.messageToDelete = ""
        }
    }
}
