//
//  MessageView.swift
//  chat-demo
//
//  Created by chen on 2025/4/30.
//

import SwiftUI

public struct MessageView: View {
    public var style: MessageStyle
    public var message: String
    public var showClose: Bool
    public var onCancelTapped: () -> Void
    
    public init(style: MessageStyle, message: String, showClose: Bool, onCancelTapped: @escaping () -> Void) {
        self.style = style
        self.message = message
        self.showClose = showClose
        self.onCancelTapped = onCancelTapped
    }
    
    public var body: some View {
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
