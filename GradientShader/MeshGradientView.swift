//
//  MeshGradientView.swift
//  GradientShader
//
//  Created by Minsang Choi on 12/11/25.
//

import SwiftUI

// MARK: - 动画模式枚举
public enum MeshGradientAnimation {
    case animated(speed: Double)  // 有动画，关联速度值 (1.0 为正常速度)
    case `static`(time: Double)   // 无动画，关联固定的 time 值 (0-100)
}

// MARK: - MeshGradient 封装视图
public struct MeshGradientView: View {
    public let colors: [Color]
    public var opacity: Double = 1.0
    public var animation: MeshGradientAnimation = .animated(speed: 1.0)
    
    // 默认颜色
    private static let defaultColors: [Color] = [
        Color(red: 0.9, green: 0.4, blue: 0.3),  // 桃色
        Color(red: 0.2, green: 0.1, blue: 0.6),  // 紫色
        Color(red: 0.0, green: 0.8, blue: 0.8),  // 青色
    ]
    
    public init(colors: [Color], opacity: Double = 1.0, animation: MeshGradientAnimation = .animated(speed: 1.0)) {
        self.colors = colors
        self.opacity = opacity
        self.animation = animation
    }
    
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
    
    public var body: some View {
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
