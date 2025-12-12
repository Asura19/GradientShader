#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

[[ stitchable ]] half4 meshGradient3(
    float2 pos,
    SwiftUI::Layer l,
    float4 bounds,
    float time,
    float3 color1,     // 颜色1 (top color, e.g. peach)
    float3 color2,     // 颜色2 (bottom-left color, e.g. purple)
    float3 color3,     // 颜色3 (bottom-right color, e.g. teal)
    float opacity      // 整体透明度
) {
    float2 size = bounds.zw;
    float2 uv = pos / size;

    // Vertical gradient with slight sine wave distortion
    float t = uv.y + 0.2 * sin(time + uv.x * 3.0);
    float p = uv.x + 0.2 * cos(time + uv.y * 6.0);
    
    // Mix between color2/color3 based on p (horizontal), then mix with color1 based on t (vertical)
    float3 bottomColor = mix(color2, color3, clamp(p, 0.0f, 1.0f));
    float3 color = mix(bottomColor, color1, clamp(t, 0.0f, 1.0f));
    
    return half4(half3(color), half(opacity));
}

