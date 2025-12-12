#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

[[ stitchable ]] half4 meshGradient4(
    float2 pos,
    SwiftUI::Layer l,
    float4 bounds,
    float time,
    float3 color1,     // 颜色1 (左上角)
    float3 color2,     // 颜色2 (右上角)
    float3 color3,     // 颜色3 (左下角)
    float3 color4,     // 颜色4 (右下角)
    float opacity      // 整体透明度
) {
    float2 size = bounds.zw;
    float2 uv = pos / size;

    // 添加动态波浪扭曲
    float wave1 = sin(time * 0.7 + uv.x * 3.0 + uv.y * 2.0) * 0.12;
    float wave2 = cos(time * 0.5 + uv.y * 4.0 - uv.x * 1.5) * 0.1;
    
    // 扭曲后的 UV 坐标
    float u = clamp(uv.x + wave1, 0.0f, 1.0f);
    float v = clamp(uv.y + wave2, 0.0f, 1.0f);
    
    // 双线性插值混合四个角的颜色
    // 先水平混合：上边 (color1 -> color2)，下边 (color3 -> color4)
    float3 topColor = mix(color1, color2, u);
    float3 bottomColor = mix(color3, color4, u);
    
    // 再垂直混合
    float3 color = mix(topColor, bottomColor, v);
    
    return half4(half3(color), half(opacity));
}
