//
//  ContentView.swift
//  GradientShader
//
//  Created by Minsang Choi on 12/11/25.
//

import SwiftUI

// MARK: - 动画模式枚举
enum MeshGradientAnimation {
    case animated(speed: Double)  // 有动画，关联速度值 (1.0 为正常速度)
    case `static`(time: Double)   // 无动画，关联固定的 time 值 (0-100)
}

// MARK: - MeshGradient 封装视图
struct MeshGradientView: View {
    let colors: [Color]
    var opacity: Double = 1.0
    var animation: MeshGradientAnimation = .animated(speed: 1.0)
    
    // 默认颜色
    private static let defaultColors: [Color] = [
        Color(red: 0.9, green: 0.4, blue: 0.3),  // 桃色
        Color(red: 0.2, green: 0.1, blue: 0.6),  // 紫色
        Color(red: 0.0, green: 0.8, blue: 0.8),  // 青色
    ]
    
    // 处理后的颜色数组
    private var processedColors: [Color] {
        if colors.count < 2 {
            return Self.defaultColors
        } else if colors.count > 4 {
            return Array(colors.prefix(4))
        }
        return colors
    }
    
    // 颜色数量
    private var colorCount: Int {
        processedColors.count
    }
    
    // 将 Color 转换为 RGB 元组
    private func colorToRGB(_ color: Color) -> (r: Float, g: Float, b: Float) {
        let resolved = color.resolve(in: EnvironmentValues())
        return (Float(resolved.red), Float(resolved.green), Float(resolved.blue))
    }
    
    var body: some View {
        switch animation {
        case .animated(let speed):
            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 100) * speed
                gradientContent(time: time)
            }
        case .static(let time):
            gradientContent(time: time)
        }
    }
    
    @ViewBuilder
    private func gradientContent(time: Double) -> some View {
        let colors = processedColors
        
        switch colorCount {
        case 2:
            let c1 = colorToRGB(colors[0])
            let c2 = colorToRGB(colors[1])
            Color.black
                .layerEffect(
                    ShaderLibrary.meshGradient2(
                        .boundingRect,
                        .float(time),
                        .float3(c1.r, c1.g, c1.b),
                        .float3(c2.r, c2.g, c2.b),
                        .float(opacity)
                    ),
                    maxSampleOffset: .zero
                )
        case 3:
            let c1 = colorToRGB(colors[0])
            let c2 = colorToRGB(colors[1])
            let c3 = colorToRGB(colors[2])
            Color.black
                .layerEffect(
                    ShaderLibrary.meshGradient3(
                        .boundingRect,
                        .float(time),
                        .float3(c1.r, c1.g, c1.b),
                        .float3(c2.r, c2.g, c2.b),
                        .float3(c3.r, c3.g, c3.b),
                        .float(opacity)
                    ),
                    maxSampleOffset: .zero
                )
        default: // 4 个颜色
            let c1 = colorToRGB(colors[0])
            let c2 = colorToRGB(colors[1])
            let c3 = colorToRGB(colors[2])
            let c4 = colorToRGB(colors[3])
            Color.black
                .layerEffect(
                    ShaderLibrary.meshGradient4(
                        .boundingRect,
                        .float(time),
                        .float3(c1.r, c1.g, c1.b),
                        .float3(c2.r, c2.g, c2.b),
                        .float3(c3.r, c3.g, c3.b),
                        .float3(c4.r, c4.g, c4.b),
                        .float(opacity)
                    ),
                    maxSampleOffset: .zero
                )
        }
    }
}

// MARK: - 2色渐变 Demo
struct TwoColorDemo: View {
    var body: some View {
        MeshGradientView(
            colors: [
                Color(red: 1.0, green: 0.4, blue: 0.7),  // 粉色
                Color(red: 0.2, green: 0.3, blue: 0.9),  // 蓝色
            ],
            animation: .animated(speed: 1.0)
        )
    }
}

// MARK: - 3色渐变 Demo
struct ThreeColorDemo: View {
    var body: some View {
        MeshGradientView(
            colors: [
                Color(red: 0.9, green: 0.4, blue: 0.3),  // 桃色
                Color(red: 0.2, green: 0.1, blue: 0.6),  // 紫色
                Color(red: 0.0, green: 0.8, blue: 0.8),  // 青色
            ],
            animation: .animated(speed: 1.0)
        )
    }
}

// MARK: - 4色渐变 Demo
struct FourColorDemo: View {
    var body: some View {
        MeshGradientView(
            colors: [
                Color(red: 0.95, green: 0.3, blue: 0.5), // 玫红
                Color(red: 1.0, green: 0.8, blue: 0.2),  // 金黄
                Color(red: 0.2, green: 0.1, blue: 0.5),  // 深紫
                Color(red: 0.0, green: 0.7, blue: 0.9),  // 天蓝
            ],
            animation: .animated(speed: 1.0)
        )
    }
}

// MARK: - 主视图
struct ContentView: View {
    @State private var selectedDemo: Int = 3
    
    var body: some View {
        ZStack {
            // 根据选择显示不同的 Demo
            Group {
                switch selectedDemo {
                case 2:
                    TwoColorDemo()
                case 3:
                    ThreeColorDemo()
                case 4:
                    FourColorDemo()
                default:
                    ThreeColorDemo()
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
                                selectedDemo = count
                            }
                        }) {
                            Text("\(count)色")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedDemo == count ? .black : .white.opacity(0.9))
                                .frame(width: 50, height: 32)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedDemo == count ? Color.white.opacity(0.9) : Color.white.opacity(0.15))
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
