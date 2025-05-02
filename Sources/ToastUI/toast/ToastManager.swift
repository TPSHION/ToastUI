import SwiftUI

@MainActor
public class ToastManager: ObservableObject {
    public static let shared = ToastManager()
    @Published private(set) var activeToasts: [ToastMessage] = []
    private let maxVisibleToasts = 3  // 最大同时显示数量
    
    private var hostWindow: UIWindow?
    private var messageQueue: [ToastMessage] = []
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
        
        queueLock.lock()
        messageQueue.append(toastMessage)
        queueLock.unlock()
        
        processNextToast(duration: duration)
    }
    
    private func processNextToast(duration: TimeInterval) {
        queueLock.lock()
        guard !messageQueue.isEmpty else {
            queueLock.unlock()
            return
        }
        
        // 如果当前显示的toast数量未达到最大值，则显示下一个
        if activeToasts.count < maxVisibleToasts {
            let nextToast = messageQueue.removeFirst()
            queueLock.unlock()
            
            withAnimation {
                activeToasts.append(nextToast)
                hostWindow?.isHidden = false
            }
            
            // 为每个toast创建独立的消失任务
            Task { [weak self] in
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                await MainActor.run {
                    withAnimation {
                        self?.activeToasts.removeAll { $0.id == nextToast.id }
                        if self?.activeToasts.isEmpty == true {
                            self?.hostWindow?.isHidden = true
                        }
                    }
                    // 处理队列中的下一条消息
                    self?.processNextToast(duration: duration)
                }
            }
        } else {
            queueLock.unlock()
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
        GeometryReader { geometry in
            VStack(spacing: 8) {
                ForEach(toastManager.activeToasts, id: \.id) { toast in
                    ToastView(message: toast.message)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .position(x: geometry.size.width / 2,
                     y: geometry.size.height - 100) // 调整位置到底部
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
