//
//  WebViewScreen.swift
//  Seerati
//
//  Path: Seerati/Features/Common/Views/WebViewScreen.swift
//
//  ─────────────────────────────────────────────────
//  AR: شاشة عرض صفحات الويب
//  EN: WebView Screen for displaying web pages
//  ─────────────────────────────────────────────────

import SwiftUI
import WebKit

// MARK: - Web View Screen
struct WebViewScreen: View {
    
    // MARK: - Properties
    let title: String
    let url: URL
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var loadError: Error?
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // WebView
                WebViewRepresentable(
                    url: url,
                    isLoading: $isLoading,
                    loadError: $loadError
                )
                
                // Loading Indicator
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(AppColors.background.opacity(0.8))
                }
                
                // Error View
                if let error = loadError {
                    errorView(error: error)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if let url = url.absoluteString.hasPrefix("http") ? url : nil {
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(AppColors.textPrimary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Error View
    private func errorView(error: Error) -> some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundStyle(AppColors.textSecondary)
            
            Text(LocalizationManager.shared.isArabic ? "تعذر تحميل الصفحة" : "Failed to load page")
                .font(AppFonts.title3(weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)
            
            Text(error.localizedDescription)
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button {
                loadError = nil
                isLoading = true
            } label: {
                Text(LocalizationManager.shared.isArabic ? "إعادة المحاولة" : "Retry")
                    .font(AppFonts.body(weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.vertical, AppSpacing.md)
                    .background(AppColors.primary)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

// MARK: - WebView Representable
struct WebViewRepresentable: UIViewRepresentable {
    
    let url: URL
    @Binding var isLoading: Bool
    @Binding var loadError: Error?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.backgroundColor = UIColor(AppColors.background)
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable
        
        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
            parent.loadError = nil
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            parent.loadError = error
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            parent.loadError = error
        }
    }
}

// MARK: - App URLs
enum AppURLs {
    // ✅ روابط GitHub Pages
    static let privacyPolicy = URL(string: "https://kaebs19.github.io/SeeratiWeb/privacy-policy.html")!
    static let termsOfUse = URL(string: "https://kaebs19.github.io/SeeratiWeb/terms-of-use.html")!
    static let contactUs = URL(string: "https://kaebs19.github.io/SeeratiWeb/contact-us.html")!
    
    // App Store
    static let appStoreID = "6756464872"
    static var appStoreURL: URL {
        URL(string: "https://apps.apple.com/app/id\(appStoreID)")!
    }
    static var appStoreReviewURL: URL {
        URL(string: "https://apps.apple.com/app/id\(appStoreID)?action=write-review")!
    }
}

// MARK: - Preview
#Preview {
    WebViewScreen(
        title: "سياسة الخصوصية",
        url: URL(string: "https://apple.com")!
    )
}
