//
//  MessageOptions.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 20/07/2022.
//

import SwiftUI

struct MessageOptions: View {
    
    var user: User
    var messages = ["Proud of you!", "You are the best", "You are amazing", "Have a wonderful day!"]
    @State var colorIndex = 0
    @State var colors: [Color] = [.oliveGreen, .moss, .raspberry, .sunglow, .tangerine, .leaf, .orange, .blue, .grenadier]

    
    var body: some View {
        ZStack(alignment: .top) {
            
            MainBackground(image: "sky-cloud-bg")
                .ignoresSafeArea()
            
            VStack {
                Text("Send a message to")
                    .font(.title3)
                    .padding()
                
                VStack(spacing: 20) {
                    ForEach(messages, id: \.self) { message in
                        MessageCard(text: message)
                            .onAppear {
                                if colorIndex >= colors.endIndex {
                                    colorIndex = 0
                                }
                                
                                colorIndex += 1
                                colors.shuffle()
                            }
                    }
                }
                .padding(.horizontal, 40)
            }
        }
    }
    
    @ViewBuilder
    func MessageCard(text: String) -> some View {
        HStack {
            Text(text)
                .padding()
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(getRandomColor())
                .frame(maxWidth: .infinity, maxHeight: 70)
                .opacity(0.4)
        }
    }
    
    func getRandomColor() -> Color {
        let index = getRandomNumber(0, colors.endIndex-1)
        print(index)
        let color = colors[index]
        return color
    }
}

struct MessageOptions_Previews: PreviewProvider {
    static let user = User(id: UUID().uuidString, name: "Pape Sow Traore")
    static var previews: some View {
        MessageOptions(user: user)
    }
}
