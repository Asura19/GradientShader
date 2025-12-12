//
//  ContentView.swift
//  GradientShader
//
//  Created by Minsang Choi on 12/11/25.
//

import SwiftUI

struct ContentView: View {
    // 可自定义的颜色
    var color1: Color = Color(red: 0.9, green: 0.4, blue: 0.3)  // peach
    var color2: Color = Color(red: 0.2, green: 0.1, blue: 0.6)  // purple
    var color3: Color = Color(red: 0.0, green: 0.8, blue: 0.8)  // teal
    var opacity: Double = 1.0  // 整体透明度
    
    var body: some View {
        ZStack {
            TimelineView(.animation) { timeline in
                
                ZStack {
                    let time = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 100)
                    
                    Color.black
                        .layerEffect(
                            ShaderLibrary.meshGradient(
                                .boundingRect,
                                .float(time),
                                .float3(0.9, 0.4, 0.3),  // color1: peach
                                .float3(0.2, 0.1, 0.6),  // color2: purple
                                .float3(0.0, 0.8, 0.8),  // color3: teal
                                .float(opacity)          // opacity
                            ),
                            maxSampleOffset: .zero
                        )
                }
                .ignoresSafeArea()
                
            }

        }
    }
}

#Preview {
    ContentView()
}
