//
//  ContentView.swift
//  GradientShader
//
//  Created by Minsang Choi on 12/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            TimelineView(.animation) { timeline in
            
                
                ZStack{
                    let time = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 100)
                    
                    Color.black
                        .layerEffect(ShaderLibrary.noisyGradient(.boundingRect, .float(time)), maxSampleOffset: .zero)

                }
                .ignoresSafeArea()
                
            }

        }
        

    }
}

#Preview {
    ContentView()
}
