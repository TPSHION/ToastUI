//
//  MessageModifier.swift
//  chat-demo
//
//  Created by chen on 2025/4/30.
//

import SwiftUI

struct MessageModifier: ViewModifier {
    @Binding var message: Message?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let message = message {
                VStack {
                    Spacer().frame(height: 60)
                    
                    MessageView(
                        style: message.style,
                        message: message.message,
                        showClose: message.showClose
                    ) {
                        dismissMessage()
                    }
                    
                    Spacer()
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: message)
                .onAppear {
                    showMessage()
                }
            }
        }
    }
    
    private func showMessage() {
        guard let message = message else { return }
        
        if message.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissMessage()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + message.duration, execute: task)
        }
    }
    
    private func dismissMessage() {
        withAnimation {
            message = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func message(message: Binding<Message?>) -> some View {
        self.modifier(MessageModifier(message: message))
    }
}
