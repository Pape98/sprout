//
//  Week.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 12/21/21.
//

import SwiftUI

struct Leaf: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.addEllipse(in: CGRect(x: 0.45615*width, y: 0.45615*height, width: 0.27322*width, height: 0.27322*height))
        path.move(to: CGPoint(x: 0.73379*width, y: 0.73379*height))
        path.addLine(to: CGPoint(x: 0.57326*width, y: 0.72849*height))
        path.addLine(to: CGPoint(x: 0.72805*width, y: 0.57371*height))
        path.addLine(to: CGPoint(x: 0.73379*width, y: 0.73379*height))
        path.closeSubpath()
        path.addEllipse(in: CGRect(x: 0.25637*width, y: 0.25637*height, width: 0.27322*width, height: 0.27322*height))
        path.move(to: CGPoint(x: 0.53401*width, y: 0.534*height))
        path.addLine(to: CGPoint(x: 0.37349*width, y: 0.52871*height))
        path.addLine(to: CGPoint(x: 0.52827*width, y: 0.37392*height))
        path.addLine(to: CGPoint(x: 0.53401*width, y: 0.534*height))
        path.closeSubpath()
        path.addEllipse(in: CGRect(x: 0.05659*width, y: 0.05659*height, width: 0.27322*width, height: 0.27322*height))
        path.move(to: CGPoint(x: 0.33422*width, y: 0.33422*height))
        path.addLine(to: CGPoint(x: 0.1737*width, y: 0.32893*height))
        path.addLine(to: CGPoint(x: 0.32849*width, y: 0.17414*height))
        path.addLine(to: CGPoint(x: 0.33422*width, y: 0.33422*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.16743*width, y: 0.16624*height))
        path.addLine(to: CGPoint(x: 0.90106*width, y: 0.89987*height))
        return path
    }
}
