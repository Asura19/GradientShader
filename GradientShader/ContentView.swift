//
//  ContentView.swift
//  GradientShader
//
//  Created by Minsang Choi on 12/11/25.
//

import SwiftUI

// MARK: - 2色渐变视图
struct GradientView2: View {
    var opacity: Double = 1.0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 100)
            
            Color.black
                .layerEffect(
                    ShaderLibrary.meshGradient2(
                        .boundingRect,
                        .float(time),
                        .float3(1.0, 0.4, 0.7),   // color1: 粉色 (顶部)
                        .float3(0.2, 0.3, 0.9),   // color2: 蓝色 (底部)
                        .float(opacity)
                    ),
                    maxSampleOffset: .zero
                )
        }
    }
}

// MARK: - 3色渐变视图
struct GradientView3: View {
    var opacity: Double = 1.0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 100)
            
            Color.black
                .layerEffect(
                    ShaderLibrary.meshGradient3(
                        .boundingRect,
                        .float(time),
                        .float3(0.9, 0.4, 0.3),   // color1: 桃色
                        .float3(0.2, 0.1, 0.6),   // color2: 紫色
                        .float3(0.0, 0.8, 0.8),   // color3: 青色
                        .float(opacity)
                    ),
                    maxSampleOffset: .zero
                )
        }
    }
}

// MARK: - 4色渐变视图
struct GradientView4: View {
    var opacity: Double = 1.0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 100)
            
            Color.black
                .layerEffect(
                    ShaderLibrary.meshGradient4(
                        .boundingRect,
                        .float(time),
                        .float3(0.95, 0.3, 0.5),  // color1: 玫红 (左上)
                        .float3(1.0, 0.8, 0.2),   // color2: 金黄 (右上)
                        .float3(0.2, 0.1, 0.5),   // color3: 深紫 (左下)
                        .float3(0.0, 0.7, 0.9),   // color4: 天蓝 (右下)
                        .float(opacity)
                    ),
                    maxSampleOffset: .zero
                )
        }
    }
}

// MARK: - 主视图
struct ContentView: View {
    @State private var selectedGradient: Int = 3
    
    var body: some View {
        ZStack {
            // 渐变背景
            Group {
                switch selectedGradient {
                case 2:
                    GradientView2()
                case 3:
                    GradientView3()
                case 4:
                    GradientView4()
                default:
                    GradientView3()
                }
            }
            .ignoresSafeArea()
            
            // 控制面板
            VStack {
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach([2, 3, 4], id: \.self) { count in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedGradient = count
                            }
                        }) {
                            Text("\(count)色")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedGradient == count ? .black : .white.opacity(0.9))
                                .frame(width: 50, height: 32)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedGradient == count ? Color.white.opacity(0.9) : Color.white.opacity(0.15))
                                )
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.3))
                )
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    ContentView()
}
