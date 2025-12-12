#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

[[ stitchable ]] half4 meshGradient2(
    float2 pos,
    SwiftUI::Layer l,
    float4 bounds,
    float time,
    float3 color1,     // 颜色1 (顶部颜色)
    float3 color2,     // 颜色2 (底部颜色)
    float opacity      // 整体透明度
) {
    float2 size = bounds.zw;
    float2 uv = pos / size;

    // 带有正弦波扭曲的垂直渐变
    float wave1 = sin(time * 0.8 + uv.x * 4.0) * 0.15;
    float wave2 = cos(time * 0.6 + uv.y * 3.0) * 0.1;
    
    // 计算混合因子，加入波浪效果
    float t = uv.y + wave1 + wave2;
    t = clamp(t, 0.0f, 1.0f);
    
    // 使用 smoothstep 让过渡更平滑
    t = smoothstep(0.0f, 1.0f, t);
    
    // 混合两个颜色
    float3 color = mix(color1, color2, t);
    
    return half4(half3(color), half(opacity));
}
