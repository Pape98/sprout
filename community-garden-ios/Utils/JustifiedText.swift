//
//  JustifiedText.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 17/10/2022.
//

import Foundation
import SwiftUI

struct JustifiedText: UIViewRepresentable {
  private let text: String
  private let font: UIFont

  init(_ text: String, font: UIFont = .systemFont(ofSize: 14)) {
    self.text = text
      if let appFont =  UIFont(name: "Baloo2-regular", size: 14) {
          self.font = appFont
      } else {
          self.font = font
      }
  }

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.font = font
    textView.textAlignment = .justified
    textView.backgroundColor = .clear
    textView.isEditable = false
      
    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
  }
}
