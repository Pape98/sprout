//
//  ProgressTriangle.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 1/1/22.
//

import SwiftUI

struct ProgressTriangle: View {
    
    var step: Step
    
    let goalDimension = 100.0
    let goalSteps = 2500.0
    
    var progressDimension: CGFloat {
        var progress = Double(step.count) * goalDimension / goalSteps
        progress = progress <= goalDimension ? progress : goalDimension
        return progress
    }
    
    var body: some View {
        VStack {
            Text(step.date)
                .font(.title3)
                .bold()
            
            ZStack (alignment: .center ){
                    Triangle()
                        .fill(Color.yellow)
                    Triangle()
                        .fill(Color.green)
                        .frame(width: progressDimension, height: progressDimension)
            }.frame(width: goalDimension, height: goalDimension)

            Text("\(step.count) / \(goalSteps.formatted()) steps")
        }

    }
}

struct ProgressTriangle_Previews: PreviewProvider {
    
    @State static var step: Step = Step(date: "22-12-1998", count: 750)
    
    static var previews: some View {
        ProgressTriangle(step:step)
    }
}
