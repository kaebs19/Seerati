//
//  AdMobManager.swift
//  Seerati
//
//  Path: Seerati/Managers/AdMobManager.swift
//
//  ─────────────────────────────────────────────────
//  AR: مدير إعلانات Google AdMob
//  EN: Google AdMob Ads Manager
//  ─────────────────────────────────────────────────

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
internal import Combine

// MARK: - Ad Unit IDs
enum AdUnitID {
    // ✅ معرفات الاختبار (للتطوير)
    #if DEBUG
    static let banner = "ca-app-pub-3940256099942544/2934735716"
    static let interstitial = "ca-app-pub-3940256099942544/4411468910"
    static let rewarded = "ca-app-pub-3940256099942544/1712485313"
    static let appOpen = "ca-app-pub-3940256099942544/5575463023"
    #else
    // ✅ معرفات الإنتاج (استبدلها بمعرفاتك)
    static let banner = "ca-app-pub-8219247197168750/8754035441"
    static let interstitial = "ca-app-pub-8219247197168750/7329273138"
    static let rewarded = "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX"
    static let appOpen = "ca-app-pub-8219247197168750/5284745489"
    #endif
}

// MARK: - AdMob Manager
@MainActor
final class AdMobManager: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = AdMobManager()
    
    // MARK: - Published Properties
    @Published var isBannerReady = false
    @Published var isInterstitialReady = false
    @Published var isRewardedReady = false
    @Published var isAppOpenReady = false
    
    // MARK: - Private Properties
    private var bannerView: BannerView?
    private var interstitialAd: InterstitialAd?
    private var rewardedAd: RewardedAd?
    private var appOpenAd: AppOpenAd?
    
    private var rewardCompletion: ((Bool) -> Void)?
    private var interstitialCompletion: (() -> Void)?
    
    // MARK: - Settings
    private let purchaseManager = PurchaseManager.shared
    
    /// هل يجب عرض الإعلانات؟
    var shouldShowAds: Bool {
        !purchaseManager.isPremium
    }
    
    // MARK: - Init
    private override init() {
        super.init()
    }
    
    // MARK: - Configure
    /// تهيئة AdMob SDK
    func configure() {
        MobileAds.shared.start { status in
            print("✅ AdMob SDK initialized")
            
            // تحميل الإعلانات
            Task { @MainActor in
                self.loadInterstitial()
                self.loadRewarded()
                self.loadAppOpenAd()
            }
        }
    }
    
    // MARK: - Request ATT Permission
    /// طلب إذن التتبع (iOS 14+)
    func requestTrackingPermission() async {
        await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("✅ Tracking authorized")
                case .denied:
                    print("❌ Tracking denied")
                case .restricted:
                    print("⚠️ Tracking restricted")
                case .notDetermined:
                    print("⏳ Tracking not determined")
                @unknown default:
                    break
                }
                continuation.resume()
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // MARK: - Banner Ads
    // ═══════════════════════════════════════════════════════════════
    
    /// إنشاء Banner View
    func createBannerView(width: CGFloat) -> BannerView {
        let banner = BannerView(adSize: currentOrientationAnchoredAdaptiveBanner(width: width))
        banner.adUnitID = AdUnitID.banner
        banner.rootViewController = getRootViewController()
        banner.delegate = self
        banner.load(Request())
        self.bannerView = banner
        return banner
    }
    
    // ═══════════════════════════════════════════════════════════════
    // MARK: - Interstitial Ads
    // ═══════════════════════════════════════════════════════════════
    
    /// تحميل إعلان Interstitial
    func loadInterstitial() {
        guard shouldShowAds else { return }
        
        InterstitialAd.load(
            with: AdUnitID.interstitial,
            request: Request()
        ) { [weak self] ad, error in
            if let error = error {
                print("❌ Interstitial load failed: \(error.localizedDescription)")
                return
            }
            
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            self?.isInterstitialReady = true
            print("✅ Interstitial loaded")
        }
    }
    
    /// عرض إعلان Interstitial
    func showInterstitial(completion: (() -> Void)? = nil) {
        guard shouldShowAds else {
            completion?()
            return
        }
        
        guard let ad = interstitialAd, isInterstitialReady else {
            print("⚠️ Interstitial not ready")
            completion?()
            loadInterstitial()
            return
        }
        
        interstitialCompletion = completion
        
        if let rootVC = getRootViewController() {
            ad.present(from: rootVC)
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // MARK: - Rewarded Ads
    // ═══════════════════════════════════════════════════════════════
    
    /// تحميل إعلان Rewarded
    func loadRewarded() {
        guard shouldShowAds else { return }
        
        RewardedAd.load(
            with: AdUnitID.rewarded,
            request: Request()
        ) { [weak self] ad, error in
            if let error = error {
                print("❌ Rewarded load failed: \(error.localizedDescription)")
                return
            }
            
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.isRewardedReady = true
            print("✅ Rewarded loaded")
        }
    }
    
    /// عرض إعلان Rewarded
    func showRewarded(completion: @escaping (Bool) -> Void) {
        guard shouldShowAds else {
            completion(true)
            return
        }
        
        guard let ad = rewardedAd, isRewardedReady else {
            print("⚠️ Rewarded not ready")
            completion(false)
            loadRewarded()
            return
        }
        
        rewardCompletion = completion
        
        if let rootVC = getRootViewController() {
            ad.present(from: rootVC) { [weak self] in
                let reward = ad.adReward
                print("✅ User earned reward: \(reward.amount) \(reward.type)")
                self?.rewardCompletion?(true)
                self?.rewardCompletion = nil
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // MARK: - App Open Ads
    // ═══════════════════════════════════════════════════════════════
    
    /// تحميل إعلان App Open
    func loadAppOpenAd() {
        guard shouldShowAds else { return }
        
        AppOpenAd.load(
            with: AdUnitID.appOpen,
            request: Request()
        ) { [weak self] ad, error in
            if let error = error {
                print("❌ App Open load failed: \(error.localizedDescription)")
                return
            }
            
            self?.appOpenAd = ad
            self?.appOpenAd?.fullScreenContentDelegate = self
            self?.isAppOpenReady = true
            print("✅ App Open loaded")
        }
    }
    
    /// عرض إعلان App Open
    func showAppOpenAd() {
        guard shouldShowAds else { return }
        
        guard let ad = appOpenAd, isAppOpenReady else {
            print("⚠️ App Open not ready")
            loadAppOpenAd()
            return
        }
        
        if let rootVC = getRootViewController() {
            ad.present(from: rootVC)
        }
    }
    
    // MARK: - Helper
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return nil
        }
        
        // البحث عن أعلى ViewController معروض
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        return topVC
    }
}

// MARK: - GADBannerViewDelegate
extension AdMobManager: BannerViewDelegate {
    
    nonisolated func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("✅ Banner loaded")
        Task { @MainActor in
            self.isBannerReady = true
        }
    }
    
    nonisolated func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        print("❌ Banner failed: \(error.localizedDescription)")
        Task { @MainActor in
            self.isBannerReady = false
        }
    }
}

// MARK: - GADFullScreenContentDelegate
extension AdMobManager: FullScreenContentDelegate {
    
    nonisolated func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        Task { @MainActor in
            // إعادة تحميل الإعلانات بعد الإغلاق
            if ad is InterstitialAd {
                self.isInterstitialReady = false
                self.interstitialCompletion?()
                self.interstitialCompletion = nil
                self.loadInterstitial()
            } else if ad is RewardedAd {
                self.isRewardedReady = false
                self.loadRewarded()
            } else if ad is AppOpenAd {
                self.isAppOpenReady = false
                self.loadAppOpenAd()
            }
        }
    }
    
    nonisolated func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Ad failed to present: \(error.localizedDescription)")
        
        Task { @MainActor in
            if ad is InterstitialAd {
                self.interstitialCompletion?()
                self.interstitialCompletion = nil
                self.loadInterstitial()
            } else if ad is RewardedAd {
                self.rewardCompletion?(false)
                self.rewardCompletion = nil
                self.loadRewarded()
            }
        }
    }
}

// ═══════════════════════════════════════════════════════════════
// MARK: - Banner View (SwiftUI)
// ═══════════════════════════════════════════════════════════════

struct BannerAdView: UIViewRepresentable {
    
    let adUnitID: String
    
    init(adUnitID: String = AdUnitID.banner) {
        self.adUnitID = adUnitID
    }
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = getRootViewController()
        banner.load(Request())
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {}
    
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return nil
        }
        return rootVC
    }
}

// MARK: - Adaptive Banner View
struct AdaptiveBannerAdView: UIViewRepresentable {
    
    @Binding var isLoaded: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView()
        banner.adUnitID = AdUnitID.banner
        banner.rootViewController = getRootViewController()
        banner.delegate = context.coordinator
        
        // حجم متكيف
        let viewWidth = UIScreen.main.bounds.width
        banner.adSize = currentOrientationAnchoredAdaptiveBanner(width: viewWidth)
        
        banner.load(Request())
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {}
    
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return nil
        }
        return rootVC
    }
    
    class Coordinator: NSObject, BannerViewDelegate {
        var parent: AdaptiveBannerAdView
        
        init(_ parent: AdaptiveBannerAdView) {
            self.parent = parent
        }
        
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            parent.isLoaded = true
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            parent.isLoaded = false
        }
    }
}

// ═══════════════════════════════════════════════════════════════
// MARK: - Ad Container View (للاستخدام السهل)
// ═══════════════════════════════════════════════════════════════

struct AdBannerContainer: View {
    
    @StateObject private var adManager = AdMobManager.shared
    @State private var isBannerLoaded = false
    
    var body: some View {
        Group {
            if adManager.shouldShowAds {
                AdaptiveBannerAdView(isLoaded: $isBannerLoaded)
                    .frame(height: isBannerLoaded ? 50 : 0)
                    .animation(.easeInOut, value: isBannerLoaded)
            }
        }
    }
}
