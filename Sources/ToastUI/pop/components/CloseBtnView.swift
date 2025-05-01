//
//  CloseBtnView.swift
//  ToastUI
//
//  Created by chen on 2025/5/1.
//

import SwiftUI

struct CloseBtnView: View {
    
    var cancel: () -> Void
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                cancel()
            }){
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(Color.black)
            }
        }
        .padding(.trailing, 15)
        .padding(.top, 15)
    }
}
