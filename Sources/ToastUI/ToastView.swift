import SwiftUI
import UIKit

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.6))
            .cornerRadius(12)
            .shadow(radius: 4)
            .frame(width: UIScreen.main.bounds.width - 30) // 设置宽度为屏幕宽度减去两边各15的边距
    }
}
