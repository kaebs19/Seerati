//
//  SeeratiApp.swift
//  Seerati
//
//  Path: Seerati/App/SeeratiApp.swift
//
//  ─────────────────────────────────────────────
//  AR: نقطة بداية التطبيق الرئيسية
//  EN: Main app entry point
//  ─────────────────────────────────────────────


import SwiftUI
import SwiftData
import GoogleMobileAds
import AppTrackingTransparency

// MARK: - Seerati App
@main
struct SeeratiApp: App {
    
    // MARK: - Properties
    let databaseManager = DatabaseManager.shared
    let userDefaults = UserDefaultsManager.shared
    let localization = LocalizationManager.shared
        
    // ✅ مدير الإعلانات
    @StateObject private var adManager = AdMobManager.shared
    
    // ✅ حالة عرض إعلان App Open
    @State private var showAppOpenAd = false
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - Init
    init() {
        // ✅ تهيئة AdMob SDK
        MobileAds.shared.start { status in
            print("✅ AdMob SDK initialized")
        }
    }
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(databaseManager.container)
                .environment(\.layoutDirection, localization.layoutDirection)
                .environmentObject(adManager)
                .onAppear {
                    setupApp()
                }
                .task {
                    // ✅ طلب إذن التتبع (ATT) - مطلوب من Apple
                    await requestTrackingPermission()
                }
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    // ✅ عرض App Open Ad عند العودة للتطبيق
                    if newPhase == .active && oldPhase == .background {
                        Task { @MainActor in
                            AdMobManager.shared.showAppOpenAd()
                        }
                    }
                }
        }
    }
    
    // MARK: - Setup
    private func setupApp() {
        userDefaults.incrementAppOpenCount()
        setupAppearance()
        
        // ✅ تحميل الإعلانات
        Task { @MainActor in
            AdMobManager.shared.loadInterstitial()
            AdMobManager.shared.loadAppOpenAd()
        }
    }
    
    // ✅ طلب إذن التتبع
    private func requestTrackingPermission() async {
        // انتظار قليل لعرض الواجهة أولاً
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 ثانية
        
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
    
    private func setupAppearance() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(AppColors.background)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(AppColors.textPrimary)]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(AppColors.textPrimary)]
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(AppColors.background)
        
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        
        UITextField.appearance().tintColor = UIColor(AppColors.primary)
    }
}

// MARK: - Content View
struct ContentView: View {
    // ✅ التحقق من عرض Onboarding
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    
    var body: some View {
        
        if hasCompletedOnboarding {
                 HomeView()
             } else {
                 OnboardingView()
             }
    }
}
