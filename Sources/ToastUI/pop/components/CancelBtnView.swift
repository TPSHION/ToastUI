//
//  CancelBtnView.swift
//  ToastUI
//
//  Created by chen on 2025/5/1.
//
import SwiftUI

struct CancelBtnView: View {
    
    var btnText: String
    var btnColor: Color
    var cancel: () -> Void
    
    var body: some View {
        Button(action: {
            cancel()
        }) {
            HStack {
                Text(btnText)
                    .font(.subheadline)
                    .foregroundStyle(btnColor)
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
                            btnColor,
                            lineWidth: 1
                        )
                )
        )
    }
}
