//
//  SideMenuStrings.swift
//  Seerati
//
//  Path: Seerati/Features/SideMenu/Resources/SideMenuStrings.swift
//
//  ─────────────────────────────────────────────
//  AR: النصوص المترجمة للقائمة الجانبية
//  EN: Localized strings for Side Menu
//  ─────────────────────────────────────────────

import Foundation

// MARK: - Side Menu Strings
enum SideMenuStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Menu Items
    static var profile: String {
        isArabic ? "الملف الشخصي" : "Profile"
    }
    
    static var myCVs: String {
        isArabic ? "سيرتي الذاتية" : "My CVs"
    }
    
    static var templates: String {
        isArabic ? "القوالب" : "Templates"
    }
    
    static var settings: String {
        isArabic ? "الإعدادات" : "Settings"
    }
    
    // MARK: - Support Section
    static var support: String {
        isArabic ? "الدعم" : "Support"
    }
    
    static var privacyPolicy: String {
        isArabic ? "سياسة الخصوصية" : "Privacy Policy"
    }
    
    static var termsOfUse: String {
        isArabic ? "شروط الاستخدام" : "Terms of Use"
    }
    
    static var contactUs: String {
        isArabic ? "اتصل بنا" : "Contact Us"
    }
    
    static var aboutApp: String {
        isArabic ? "حول التطبيق" : "About"
    }
    
    static var rateApp: String {
        isArabic ? "قيّم التطبيق" : "Rate App"
    }
    
    static var shareApp: String {
        isArabic ? "شارك التطبيق" : "Share App"
    }
    
    // MARK: - Version
    static var version: String {
        isArabic ? "الإصدار" : "Version"
    }
    
    // MARK: - Language
    static var language: String {
        isArabic ? "اللغة" : "Language"
    }
    
    static var arabic: String {
        isArabic ? "العربية" : "Arabic"
    }
    
    static var english: String {
        isArabic ? "الإنجليزية" : "English"
    }
}
