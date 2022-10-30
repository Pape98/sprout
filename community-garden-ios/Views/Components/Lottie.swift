//
//  Lottie.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 16/08/2022.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    typealias UIViewType = UIView
    var filename: String
    var loopMode: LottieLoopMode = .loop
    var contentMode: UIView.ContentMode = .scaleAspectFit

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animation = Animation.named(filename)
        let animationView = AnimationView()
        animationView.frame = view.bounds

        animationView.animation = animation
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        return view
      
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
    
    
//    func backgroundBehavior(_ behavior: Lottie.LottieBackgroundBehavior) -> Self {
//            var view = self
//            view.backgroundBehavior = behavior
//
//            return view
//        }
}

