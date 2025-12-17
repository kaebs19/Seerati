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

// MARK: - Seerati App
@main
struct SeeratiApp: App {
    
    // MARK: - Properties
    
    /// مدير قاعدة البيانات
    let databaseManager = DatabaseManager.shared
    
    /// مدير الإعدادات
    let userDefaults = UserDefaultsManager.shared
    
    /// مدير اللغة
    let localization = LocalizationManager.shared
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(databaseManager.container)
                .environment(\.layoutDirection, localization.layoutDirection)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    // MARK: - Setup
    private func setupApp() {
        // زيادة عداد فتح التطبيق
        userDefaults.incrementAppOpenCount()
        
        // تطبيق الثيم
        setupAppearance()
    }
    
    private func setupAppearance() {
        // Navigation Bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(AppColors.background)
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.textPrimary)
        ]
        navAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(AppColors.textPrimary)
        ]
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        
        // Tab Bar
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(AppColors.background)
        
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        
        // Text Field
        UITextField.appearance().tintColor = UIColor(AppColors.primary)
    }
}

// MARK: - Content View
struct ContentView: View {
    
    var body: some View {
        HomeView()
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
