//
//  SettingsViewModel.swift
//  Seerati
//
//  Path: Seerati/Features/Settings/ViewModels/SettingsViewModel.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة حالة ومنطق شاشة الإعدادات
//  EN: Settings screen state and logic
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Settings ViewModel
@Observable
final class SettingsViewModel {
    
    // MARK: - Managers
    let themeManager = ThemeManager.shared
    let purchaseManager = PurchaseManager.shared
    let localizationManager = LocalizationManager.shared
    
    // MARK: - State
    var isRestoring: Bool = false
    var showRestoreSuccess: Bool = false
    var showRestoreError: Bool = false
    var showPremiumPlans: Bool = false
    
    // Export Settings
    var exportQuality: ExportQuality {
        get { UserDefaultsManager.shared.exportQuality }
        set { UserDefaultsManager.shared.exportQuality = newValue }
    }
    
    var pageSize: PageSize = .a4
    
    // MARK: - Computed
    
    /// هل المستخدم Premium؟
    var isPremium: Bool {
        purchaseManager.isPremium
    }
    
    /// الثيم الحالي
    var currentTheme: AppThemeMode {
        get { themeManager.currentTheme }
        set { themeManager.setTheme(newValue) }
    }
    
    /// اللغة الحالية
    var currentLanguage: Language {
        localizationManager.currentLanguage
    }
    
    /// التصديرات المتبقية
    var remainingExports: Int {
        purchaseManager.remainingExports
    }
    
    /// نص التصديرات
    var exportsText: String {
        if isPremium {
            return "∞"
        }
        return SettingsStrings.exportsCount(
            purchaseManager.freeExportLimit - remainingExports,
            max: purchaseManager.freeExportLimit
        )
    }
    
    /// إصدار التطبيق
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    // MARK: - Methods
    
    /// تغيير اللغة
    func setLanguage(_ language: Language) {
        localizationManager.setLanguage(language)
    }
    
    /// استعادة المشتريات
    func restorePurchases() async {
        isRestoring = true
        
        let success = await purchaseManager.restorePurchases()
        
        await MainActor.run {
            isRestoring = false
            if success {
                showRestoreSuccess = true
            } else {
                showRestoreError = true
            }
        }
    }
    
    /// شراء Premium
    func purchasePremium(yearly: Bool) async -> Bool {
        return await purchaseManager.purchasePremium(yearly: yearly)
    }
}

// MARK: - Page Size
enum PageSize: String, CaseIterable, Identifiable {
    case a4 = "A4"
    case letter = "Letter"
    case legal = "Legal"
    
    var id: String { rawValue }
    
    var displayName: String { rawValue }
    
    var size: CGSize {
        switch self {
        case .a4: return CGSize(width: 595, height: 842)
        case .letter: return CGSize(width: 612, height: 792)
        case .legal: return CGSize(width: 612, height: 1008)
        }
    }
}
