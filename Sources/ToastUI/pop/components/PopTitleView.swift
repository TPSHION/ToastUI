//
//  PopTitleView.swift
//  ToastUI
//
//  Created by chen on 2025/5/1.
//
import SwiftUI

struct PopTitleView: View {
    
    var title: String
    
    var body: some View {
        HStack{
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.black)
        }
        .padding(.bottom, 20)
    }
}
