//
//  ConfirmBtnView.swift
//  ToastUI
//
//  Created by chen on 2025/5/1.
//
import SwiftUI

struct ConfirmBtnView: View {
    
    var btnText: String
    var btnColor: Color
    var confirm: () -> Void
    
    var body: some View {
        Button(action: {
            confirm()
        }) {
            HStack {
                Text(btnText)
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
                .fill(btnColor)
        )
    }
}
