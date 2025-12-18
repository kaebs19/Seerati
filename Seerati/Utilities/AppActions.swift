//
//  AppActions.swift
//  Seerati
//
//  Path: Seerati/Utilities/AppActions.swift
//
//  ─────────────────────────────────────────────────
//  AR: إجراءات التطبيق (التقييم، المشاركة، إلخ)
//  EN: App Actions (Rate, Share, etc.)
//  ─────────────────────────────────────────────────

import SwiftUI
import StoreKit

// MARK: - App Actions
final class AppActions {
    
    // MARK: - Singleton
    static let shared = AppActions()
    private init() {}
    
    // MARK: - App Store ID
    private let appStoreID = "6756464872"
    
    // MARK: - Rate App
    /// فتح صفحة التقييم في App Store
    func rateApp() {
        // Try native review prompt first
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            
            // Request review through StoreKit
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    /// فتح صفحة التقييم في المتجر مباشرة
    func openAppStoreReview() {
        guard let url = URL(string: "https://apps.apple.com/app/id\(appStoreID)?action=write-review") else { return }
        UIApplication.shared.open(url)
    }
    
    /// فتح صفحة التطبيق في المتجر
    func openAppStore() {
        guard let url = URL(string: "https://apps.apple.com/app/id\(appStoreID)") else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Share App
    /// مشاركة التطبيق
    func shareApp() {
        let appURL = "https://apps.apple.com/app/id\(appStoreID)"
        let message = """
        📝 جرب تطبيق سيرتي - أفضل تطبيق لإنشاء السير الذاتية الاحترافية!
        
        ✨ قوالب احترافية
        🌐 دعم العربية والإنجليزية  
        📄 تصدير PDF
        
        حمّله الآن:
        \(appURL)
        """
        
        let activityVC = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil
        )
        
        // Present
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            
            // For iPad
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(
                x: rootVC.view.bounds.midX,
                y: rootVC.view.bounds.midY,
                width: 0,
                height: 0
            )
            
            rootVC.present(activityVC, animated: true)
        }
    }
    
    // MARK: - Contact Support
    /// فتح البريد للتواصل
    func contactSupport() {
        let email = "support@seeratiapp.com"
        let subject = "دعم تطبيق سيرتي"
        let body = """
        
        ─────────────────
        معلومات الجهاز:
        • الجهاز: \(UIDevice.current.model)
        • النظام: iOS \(UIDevice.current.systemVersion)
        • التطبيق: \(appVersion)
        ─────────────────
        """
        
        let urlString = "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Open URL
    /// فتح رابط خارجي
    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
    
    /// فتح رابط من نص
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - App Info
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var fullVersion: String {
        "\(appVersion) (\(buildNumber))"
    }
}

// MARK: - SwiftUI Environment
struct AppActionsKey: EnvironmentKey {
    static let defaultValue = AppActions.shared
}

extension EnvironmentValues {
    var appActions: AppActions {
        get { self[AppActionsKey.self] }
        set { self[AppActionsKey.self] = newValue }
    }
}
