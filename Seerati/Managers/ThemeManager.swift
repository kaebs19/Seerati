//
//  ThemeManager.swift
//  Seerati
//
//  Path: Seerati/Managers/ThemeManager.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة ثيم التطبيق (نظام/داكن/فاتح)
//  EN: App theme management (system/dark/light)
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - App Theme
enum AppThemeMode: String, CaseIterable, Identifiable {
    case system = "system"
    case dark = "dark"
    case light = "light"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system: return SettingsStrings.themeSystem
        case .dark: return SettingsStrings.themeDark
        case .light: return SettingsStrings.themeLight
        }
    }
    
    var icon: String {
        switch self {
        case .system: return "iphone"
        case .dark: return "moon.fill"
        case .light: return "sun.max.fill"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .dark: return .dark
        case .light: return .light
        }
    }
}

// MARK: - Theme Manager
@Observable
final class ThemeManager {
    
    // MARK: - Singleton
    static let shared = ThemeManager()
    
    // MARK: - Properties
    var currentTheme: AppThemeMode {
        didSet {
            saveTheme()
            applyTheme()
        }
    }
    
    // MARK: - Keys
    private let themeKey = "app_theme_mode"
    
    // MARK: - Init
    private init() {
        // Load saved theme
        if let savedTheme = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppThemeMode(rawValue: savedTheme) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .system
        }
    }
    
    // MARK: - Methods
    
    /// حفظ الثيم
    private func saveTheme() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: themeKey)
    }
    
    /// تطبيق الثيم
    func applyTheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            switch self.currentTheme {
            case .system:
                window.overrideUserInterfaceStyle = .unspecified
            case .dark:
                window.overrideUserInterfaceStyle = .dark
            case .light:
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    /// تغيير الثيم
    func setTheme(_ theme: AppThemeMode) {
        currentTheme = theme
    }
    
    /// هل الوضع الداكن مفعّل؟
    var isDarkMode: Bool {
        switch currentTheme {
        case .dark:
            return true
        case .light:
            return false
        case .system:
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
    }
}

// MARK: - Theme View Modifier
struct ThemeModifier: ViewModifier {
    @State private var themeManager = ThemeManager.shared
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}

extension View {
    func applyTheme() -> some View {
        modifier(ThemeModifier())
    }
}
