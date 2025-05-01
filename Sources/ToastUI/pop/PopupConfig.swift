//
//  PopupConfig.swift
//  ToastUI
//
//  Created by chen on 2025/5/1.
//
import SwiftUI

@MainActor
public struct PopupConfig {
    
    public var backgroundColor: Color = .white
    public var tintColor: Color = Color(hex: "#27BC9E")
    public var cancelText: String = "取消"
    public var confirmText: String = "确定"
    public var width: CGFloat = UIScreen.main.bounds.width - 70
    public var height: CGFloat = 160
    
    public init() {}
}
