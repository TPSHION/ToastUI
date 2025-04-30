//
//  MessageStyle.swift
//  chat-demo
//
//  Created by chen on 2025/4/30.
//

import SwiftUI

enum MessageStyle {
    case success
    case error
    case warning
    case info
    
    var themeColor: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
}
