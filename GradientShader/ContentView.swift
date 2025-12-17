//
//  ContentView.swift
//  GradientShader
//
//  Created by Minsang Choi on 12/11/25.
//

import SwiftUI

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
