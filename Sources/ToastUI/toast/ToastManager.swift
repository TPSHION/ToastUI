import SwiftUI

@MainActor
public class ToastManager: ObservableObject {
    public static let shared = ToastManager()
    @Published var currentToast: ToastMessage?
    
    private var hostWindow: UIWindow?
    private var messageQueue: [ToastMessage] = []
    private var isShowingToast = false
    private let queueLock = NSRecursiveLock()
    
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
        let toastMessage = ToastMessage(message: message)
        
        // 只在修改队列时加锁
        queueLock.lock()
        messageQueue.append(toastMessage)
        let shouldStartShowing = !isShowingToast
        queueLock.unlock()
        
        if shouldStartShowing {
            showNextToast(duration: duration)
        }
    }
    
    private func showNextToast(duration: TimeInterval) {
        var nextToast: ToastMessage?
        var shouldContinue = false
        
        // 最小化锁定范围
        queueLock.lock()
        if !messageQueue.isEmpty {
            nextToast = messageQueue.first
            isShowingToast = true
            shouldContinue = true
        } else {
            isShowingToast = false
            hostWindow?.isHidden = true
            shouldContinue = false
        }
        queueLock.unlock()
        
        guard shouldContinue, let toast = nextToast else { return }
        
        withAnimation {
            currentToast = toast
            hostWindow?.isHidden = false
        }
        
        Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            await MainActor.run {
                withAnimation {
                    // 只在移除队列元素时加锁
                    self?.queueLock.lock()
                    self?.messageQueue.removeFirst()
                    self?.queueLock.unlock()
                    
                    self?.currentToast = nil
                    self?.showNextToast(duration: duration)
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
