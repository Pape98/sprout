//
//  FloatingAnimal.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 15/10/2022.
//

import SwiftUI

struct FloatingAnimal: View {
    
    
    var animals: [String] = ["peguin_waving-hello",
                             "dog-walking", "koala-laughing","sleeping-bear"]
    
    var currentAnimalIndex = Int.random(in: 0..<4)
    var animal: String = "dog-walking"
    
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.white)
                .frame(width: 70)
                .opacity(0.8)
            LottieView(filename: animal)
                .frame(width: 70, height: 70,alignment: .bottomTrailing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding()
    }
}

struct FloatingAnimal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            FloatingAnimal()
        }
    }
}
