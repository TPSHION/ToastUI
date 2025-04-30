//
//  Message.swift
//  chat-demo
//
//  Created by chen on 2025/4/30.
//
import SwiftUI

public struct Message: Equatable {
    var style: MessageStyle
    var message: String
    var duration: Double = 2.0
    var showClose: Bool = true
    
    public init(style: MessageStyle, message: String, duration: Double = 2.0, showClose: Bool = true) {
        self.style = style
        self.message = message
        self.duration = duration
        self.showClose = showClose
    }
}
