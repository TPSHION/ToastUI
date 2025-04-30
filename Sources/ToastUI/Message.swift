//
//  Message.swift
//  chat-demo
//
//  Created by chen on 2025/4/30.
//
import SwiftUI

struct Message: Equatable {
    var style: MessageStyle
    var message: String
    var duration: Double = 2.0
    var showClose: Bool = true
}
