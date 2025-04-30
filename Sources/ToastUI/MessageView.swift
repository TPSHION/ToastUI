//
//  MessageView.swift
//  chat-demo
//
//  Created by chen on 2025/4/30.
//

import SwiftUI

struct MessageView: View {
    var style: MessageStyle
    var message: String
    var showClose: Bool
    var onCancelTapped: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.icon)
                .foregroundColor(style.themeColor)
                .font(.system(size: 20))
            
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 10)
            
            if showClose {
                Button {
                    onCancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(style.themeColor)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(minWidth: 0, maxWidth: 350)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}
