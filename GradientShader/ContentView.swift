//
//  ContentView.swift
//  GradientShader
//
//  Created by Minsang Choi on 12/11/25.
//

import SwiftUI

// MARK: - Demo 类型枚举
enum DemoType: String, CaseIterable {
    case shader = "Shader"
    case native = "Native"
}

// MARK: - 2色渐变 Demo (Shader)
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

// MARK: - 3色渐变 Demo (Shader)
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

// MARK: - 4色渐变 Demo (Shader)
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

// MARK: - iOS 18 原生 MeshGradient 静态 Demo
@available(iOS 18.0, macOS 15.0, *)
struct NativeStaticMeshGradientDemo: View {
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                // 第一行
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                // 第二行
                .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                // 第三行
                .init(0, 1), .init(0.5, 1), .init(1, 1)
            ],
            colors: [
                // 第一行颜色
                Color(red: 0.95, green: 0.3, blue: 0.5),   // 玫红
                Color(red: 0.8, green: 0.2, blue: 0.8),    // 紫红
                Color(red: 0.3, green: 0.2, blue: 0.9),    // 靛蓝
                // 第二行颜色
                Color(red: 1.0, green: 0.6, blue: 0.3),    // 橙色
                Color(red: 0.6, green: 0.4, blue: 0.9),    // 淡紫
                Color(red: 0.2, green: 0.6, blue: 0.95),   // 天蓝
                // 第三行颜色
                Color(red: 1.0, green: 0.85, blue: 0.2),   // 金黄
                Color(red: 0.2, green: 0.85, blue: 0.5),   // 翠绿
                Color(red: 0.3, green: 0.9, blue: 0.85)    // 青色
            ]
        )
    }
}

// MARK: - iOS 18 原生 MeshGradient 动态 Demo
@available(iOS 18.0, macOS 15.0, *)
struct NativeAnimatedMeshGradientDemo: View {
    @State private var isAnimating = false
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                // 第一行
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                // 第二行 - 中间点会移动
                [0.0, 0.5], [isAnimating ? 0.1 : 0.9, 0.5], [1.0, isAnimating ? 0.2 : 0.8],
                // 第三行
                [0.0, 1.0], [isAnimating ? 0.8 : 0.2, 1.0], [1.0, 1.0]
            ],
            colors: [
                // 第一行颜色
                Color(red: 0.95, green: 0.3, blue: 0.5),   // 玫红
                Color(red: 0.8, green: 0.2, blue: 0.8),    // 紫红
                Color(red: 0.3, green: 0.2, blue: 0.9),    // 靛蓝
                // 第二行颜色 - 颜色也会变化
                isAnimating ? Color(red: 0.3, green: 0.9, blue: 0.85) : Color(red: 1.0, green: 0.6, blue: 0.3),
                Color(red: 0.6, green: 0.4, blue: 0.9),    // 淡紫
                Color(red: 0.2, green: 0.6, blue: 0.95),   // 天蓝
                // 第三行颜色
                Color(red: 1.0, green: 0.85, blue: 0.2),   // 金黄
                isAnimating ? Color(red: 0.95, green: 0.3, blue: 0.5) : Color(red: 0.2, green: 0.85, blue: 0.5),
                Color(red: 0.3, green: 0.9, blue: 0.85)    // 青色
            ],
            smoothsColors: true
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - iOS 18 原生 Demo 容器（处理版本兼容）
struct NativeMeshGradientDemoContainer: View {
    let isAnimated: Bool
    
    var body: some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            if isAnimated {
                NativeAnimatedMeshGradientDemo()
            } else {
                NativeStaticMeshGradientDemo()
            }
        } else {
            // iOS 18 以下显示提示
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                Text("原生 MeshGradient 需要 iOS 18+")
                    .font(.headline)
                Text("请使用 Shader 版本")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.9))
        }
    }
}

// MARK: - 主视图
struct ContentView: View {
    @State private var selectedDemo: Int = 3
    @State private var demoType: DemoType = .shader
    @State private var isAnimated: Bool = true
    
    var body: some View {
        ZStack {
            // 根据选择显示不同的 Demo
            Group {
                switch demoType {
                case .shader:
                    // Shader 版本的 Demo
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
                case .native:
                    // iOS 18 原生 MeshGradient Demo
                    NativeMeshGradientDemoContainer(isAnimated: isAnimated)
                }
            }
            .ignoresSafeArea()
            
            // 控制面板
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    // Demo 类型选择器
                    HStack(spacing: 8) {
                        ForEach(DemoType.allCases, id: \.self) { type in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    demoType = type
                                }
                            }) {
                                Text(type.rawValue)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(demoType == type ? .black : .white.opacity(0.9))
                                    .frame(width: 70, height: 30)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(demoType == type ? Color.white.opacity(0.9) : Color.white.opacity(0.15))
                                    )
                            }
                        }
                    }
                    
                    // 子选项
                    if demoType == .shader {
                        // Shader 颜色数选择
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
                    } else {
                        // Native 动画选择
                        HStack(spacing: 8) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isAnimated = false
                                }
                            }) {
                                Text("静态")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(!isAnimated ? .black : .white.opacity(0.9))
                                    .frame(width: 60, height: 32)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(!isAnimated ? Color.white.opacity(0.9) : Color.white.opacity(0.15))
                                    )
                            }
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isAnimated = true
                                }
                            }) {
                                Text("动态")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(isAnimated ? .black : .white.opacity(0.9))
                                    .frame(width: 60, height: 32)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(isAnimated ? Color.white.opacity(0.9) : Color.white.opacity(0.15))
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
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
