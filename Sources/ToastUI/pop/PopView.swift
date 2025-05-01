//
//  PopView.swift
//  ToastUI
//
//  Created by chen on 2025/4/30.
//

import SwiftUI

public struct PopView: View {
    
    public var title: String
    public var config: PopupConfig
    public var showCancel: Bool = true
    public var cancel: () -> Void
    public var confirm: () -> Void
    
    public init(title: String,
                config: PopupConfig,
                showCancel: Bool = true,
                cancel: @escaping () -> Void,
                confirm: @escaping () -> Void){
        
        self.title = title
        self.config = config
        self.showCancel = showCancel
        self.cancel = cancel
        self.confirm = confirm
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                CloseBtnView{
                    cancel()
                }
                
                Spacer()
                
                PopTitleView(title: title)
                
                HStack(spacing: 25){
                    if showCancel {
                        CancelBtnView(btnText: config.cancelText,
                                      btnColor: config.tintColor) {
                            cancel()
                        }
                    }

                    ConfirmBtnView(btnText: config.confirmText,
                                   btnColor: config.tintColor){
                        confirm()
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
            }
            .frame(width: config.width, height: config.height)
            .background(config.backgroundColor)
            .cornerRadius(12)
            .shadow(radius: 8)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
