//
//  ColorExtension.swift
//  ToastUI
//
//  Created by chen on 2025/5/1.
//
import SwiftUI

extension Color {
    // 支持6位或8位十六进制颜色（如 #RRGGBB 或 #RRGGBBAA）
    init(hex: String, alpha: Double = 1.0) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        
        // 处理8位十六进制（包含透明度）
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
        
        if hexSanitized.count == 6 {
            // 6位十六进制（无透明度）
            red   = Double((rgb & 0xFF0000) >> 16) / 255.0
            green = Double((rgb & 0x00FF00) >> 8) / 255.0
            blue  = Double(rgb & 0x0000FF) / 255.0
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
        } else if hexSanitized.count == 8 {
            // 8位十六进制（包含透明度）
            red   = Double((rgb & 0xFF000000) >> 24) / 255.0
            green = Double((rgb & 0x00FF0000) >> 16) / 255.0
            blue  = Double((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = Double(rgb & 0x000000FF) / 255.0
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
        } else {
            // 默认黑色，如果格式错误
            self.init(.black)
        }
    }
}
