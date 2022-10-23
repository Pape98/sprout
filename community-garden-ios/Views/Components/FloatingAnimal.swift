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
        GeometryReader { geo in
            ZStack(alignment: .bottomTrailing) {
                LottieView(filename: animal)
                    .frame(width: 70, height: 70)
                    .background {
                        Circle()
                            .fill(Color.appleGreen)
                            .frame(width: 70)
                            .opacity(0.2)
                    }
            }
            .frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .bottomTrailing)
            .padding()
        }
    }
}

struct FloatingAnimal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            FloatingAnimal()
        }
    }
}
