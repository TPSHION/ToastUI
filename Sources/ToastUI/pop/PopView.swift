//
//  PopView.swift
//  ToastUI
//
//  Created by chen on 2025/4/30.
//

import SwiftUI

public struct PopView: View {
    
    public var title: String
    public var cancel: () -> Void
    public var confirm: () -> Void
    public var showCancel: Bool = true
    
    public init(title: String, showCancel: Bool = true,
                cancel: @escaping () -> Void, confirm: @escaping () -> Void){
        self.title = title
        self.showCancel = showCancel
        self.cancel = cancel
        self.confirm = confirm
    }
    
    public var body: some View {
        VStack{
            Spacer()
            
            VStack(spacing: 0) {
                CloseBtnView{
                    cancel()
                }
                
                Spacer()
                
                PopTitleView(title: title)
                
                HStack(spacing: 25){
                    if showCancel {
                        CancelBtnView {
                            cancel()
                        }
                    }

                    ConfirmBtnView{
                        confirm()
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: 160)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 8)
            .padding(.horizontal, 35)
            
            Spacer()
        }
        .background(
            // 背景遮罩
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        cancel()
                    }
                }
        )
    }
}

struct CloseBtnView: View {
    
    var cancel: () -> Void
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                cancel()
            }){
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(Color.black)
            }
        }
        .padding(.trailing, 15)
        .padding(.top, 15)
    }
}

struct PopTitleView: View {
    
    var title: String
    
    var body: some View {
        HStack{
            Text("\(title)")
                .font(.headline)
                .foregroundStyle(Color.black)
        }
        .padding(.bottom, 20)
    }
}

struct CancelBtnView: View {
    
    var cancel: () -> Void
    
    var body: some View {
        Button(action: {
            cancel()
        }) {
            HStack {
                Text("取消")
                    .font(.subheadline)
                    .foregroundStyle(Color(hex: "#27BC9E"))
            }
            .padding(.leading, 45)
            .padding(.trailing, 45)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
        // 使用圆角矩形作为背景
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white)
                // 可选：添加边框到背景
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(
                            Color(hex: "#27BC9E"),
                            lineWidth: 1
                        )
                )
        )
    }
}

struct ConfirmBtnView: View {
    
    var confirm: () -> Void
    
    var body: some View {
        Button(action: {
            confirm()
        }) {
            HStack {
                Text("确定")
                    .font(.subheadline)
                    .foregroundStyle(Color.white)
            }
            .padding(.leading, 45)
            .padding(.trailing, 45)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
        // 使用圆角矩形作为背景
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "#27BC9E"))
        )
    }
}

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
