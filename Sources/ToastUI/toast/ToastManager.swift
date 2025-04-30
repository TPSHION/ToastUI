import SwiftUI

@MainActor
public class ToastManager: ObservableObject {
    public static let shared = ToastManager()
    @Published var currentToast: ToastMessage?
    
    private var hostWindow: UIWindow?
    private init() {
        setupToastWindow()
    }
    
    private func setupToastWindow() {
        let windowScene = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first
        
        let window = UIWindow(windowScene: windowScene!)
        window.backgroundColor = .clear
        window.windowLevel = .alert
        window.isUserInteractionEnabled = false
        
        let hostController = UIHostingController(rootView: ToastContainerView())
        hostController.view.backgroundColor = .clear
        window.rootViewController = hostController
        
        self.hostWindow = window
    }
    
    public func show(_ message: String, duration: TimeInterval = 3.0) {
        withAnimation {
            currentToast = ToastMessage(message: message)
            hostWindow?.isHidden = false
        }
        
        Task { [weak self] in
            // 使用 nanoseconds 替代 seconds
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            await MainActor.run {
                withAnimation {
                    self?.currentToast = nil
                    self?.hostWindow?.isHidden = true
                }
            }
        }
    }
}

struct ToastMessage: Equatable, Sendable {
    let id = UUID()
    let message: String
}

private struct ToastContainerView: View {
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        GeometryReader { _ in
            if let toast = toastManager.currentToast {
                ToastView(message: toast.message)
                    .transition(.opacity)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            }
        }
        .ignoresSafeArea()
    }
}

// 全局函数
@MainActor
public func Toast(_ message: String, duration: TimeInterval = 2.0) {
    ToastManager.shared.show(message, duration: duration)
}

// 提供一个非异步的便捷方法
public func ToastAsync(_ message: String, duration: TimeInterval = 2.0) {
    Task { @MainActor in
        ToastManager.shared.show(message, duration: duration)
    }
}
