//
//  PopupModifier.swift
//  ToastUI
//
//  Created by chen on 2025/5/1.
//
import SwiftUI

struct PopupModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    let title: String
    let config: PopupConfig
    let onCancel: () -> Void
    let onConfirm: () -> Void
    let showCancel: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
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

extension View {
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
