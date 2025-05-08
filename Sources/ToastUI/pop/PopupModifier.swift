//
//  PopupModifier.swift
//  ToastUI
//
//  Created by chen on 2025/5/1.
//
import SwiftUI

public struct PopupModifier: ViewModifier {
    
    @Binding public var isPresented: Bool
    
    public let title: String
    public let config: PopupConfig
    public let onCancel: () -> Void
    public let onConfirm: () -> Void
    public let showCancel: Bool
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                ZStack{
                    PopView(
                        title: title,
                        config: config,
                        showCancel: showCancel,
                        cancel: {
                            onCancel()
                            isPresented = false
                        },
                        confirm: {
                            onConfirm()
                            isPresented = false
                        }
                    )
                }
            }
        }
    }
}

public extension View {
    func popup(
        isPresented: Binding<Bool>,
        title: String,
        config: PopupConfig = PopupConfig(),
        showCancel: Bool = true,
        onCancel: @escaping () -> Void = {},
        onConfirm: @escaping () -> Void = {}
    ) -> some View {
        modifier(PopupModifier(
            isPresented: isPresented,
            title: title,
            config: config,
            onCancel: onCancel,
            onConfirm: onConfirm,
            showCancel: showCancel
        ))
    }
}
