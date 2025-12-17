//
//  SettingsStrings.swift
//  Seerati
//
//  Path: Seerati/Features/Settings/Resources/SettingsStrings.swift
//
//  ─────────────────────────────────────────────
//  AR: النصوص المترجمة لشاشة الإعدادات
//  EN: Localized strings for Settings screen
//  ─────────────────────────────────────────────

import Foundation

// MARK: - Settings Strings
enum SettingsStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Navigation
    static var title: String {
        isArabic ? "الإعدادات" : "Settings"
    }
    
    static var done: String {
        isArabic ? "تم" : "Done"
    }
    
    // MARK: - Premium Card
    static var upgradeToPremium: String {
        isArabic ? "ترقية إلى Premium" : "Upgrade to Premium"
    }
    
    static var premiumFeature1: String {
        isArabic ? "جميع القوالب" : "All Templates"
    }
    
    static var premiumFeature2: String {
        isArabic ? "تصدير غير محدود" : "Unlimited Exports"
    }
    
    static var premiumFeature3: String {
        isArabic ? "بدون علامة مائية" : "No Watermark"
    }
    
    static var viewPlans: String {
        isArabic ? "عرض الباقات" : "View Plans"
    }
    
    static var youArePremium: String {
        isArabic ? "أنت مشترك Premium ⭐" : "You are Premium ⭐"
    }
    
    // MARK: - Sections
    static var account: String {
        isArabic ? "الحساب" : "Account"
    }
    
    static var appearance: String {
        isArabic ? "المظهر" : "Appearance"
    }
    
    static var export: String {
        isArabic ? "التصدير" : "Export"
    }
    
    static var about: String {
        isArabic ? "حول" : "About"
    }
    
    // MARK: - Account
    static var defaultInfo: String {
        isArabic ? "معلوماتي الافتراضية" : "My Default Info"
    }
    
    static var restorePurchases: String {
        isArabic ? "استعادة المشتريات" : "Restore Purchases"
    }
    
    static var restoring: String {
        isArabic ? "جاري الاستعادة..." : "Restoring..."
    }
    
    static var restoreSuccess: String {
        isArabic ? "تم استعادة المشتريات بنجاح" : "Purchases restored successfully"
    }
    
    static var restoreFailed: String {
        isArabic ? "فشل في استعادة المشتريات" : "Failed to restore purchases"
    }
    
    // MARK: - Appearance
    static var theme: String {
        isArabic ? "الثيم" : "Theme"
    }
    
    static var language: String {
        isArabic ? "اللغة" : "Language"
    }
    
    static var themeSystem: String {
        isArabic ? "النظام" : "System"
    }
    
    static var themeDark: String {
        isArabic ? "داكن" : "Dark"
    }
    
    static var themeLight: String {
        isArabic ? "فاتح" : "Light"
    }
    
    // MARK: - Export
    static var pdfQuality: String {
        isArabic ? "جودة PDF" : "PDF Quality"
    }
    
    static var pageSize: String {
        isArabic ? "حجم الصفحة" : "Page Size"
    }
    
    static var qualityLow: String {
        isArabic ? "منخفضة" : "Low"
    }
    
    static var qualityMedium: String {
        isArabic ? "متوسطة" : "Medium"
    }
    
    static var qualityHigh: String {
        isArabic ? "عالية" : "High"
    }
    
    // MARK: - Export Limit
    static var exportsRemaining: String {
        isArabic ? "التصديرات المتبقية" : "Exports Remaining"
    }
    
    static func exportsCount(_ count: Int, max: Int) -> String {
        isArabic ? "\(count) من \(max) هذا الشهر" : "\(count) of \(max) this month"
    }
    
    static var exportLimitReached: String {
        isArabic ? "وصلت للحد الأقصى من التصديرات هذا الشهر" : "You've reached your export limit this month"
    }
    
    static var upgradeForUnlimited: String {
        isArabic ? "ترقية للتصدير غير المحدود" : "Upgrade for unlimited exports"
    }
    
    // MARK: - About
    static var version: String {
        isArabic ? "الإصدار" : "Version"
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
    
    // MARK: - Purchase Template
    static var purchaseTemplate: String {
        isArabic ? "شراء القالب" : "Purchase Template"
    }
    
    static func purchaseTemplateMessage(_ name: String, price: String) -> String {
        isArabic 
            ? "هل تريد شراء قالب \(name)؟\n\nالسعر: \(price)\n(شراء لمرة واحدة)"
            : "Do you want to purchase \(name) template?\n\nPrice: \(price)\n(One-time purchase)"
    }
    
    static var purchase: String {
        isArabic ? "شراء" : "Purchase"
    }
    
    static var cancel: String {
        isArabic ? "إلغاء" : "Cancel"
    }
    
    static var purchaseSuccess: String {
        isArabic ? "تم الشراء بنجاح!" : "Purchase successful!"
    }
    
    static var purchaseFailed: String {
        isArabic ? "فشل في الشراء" : "Purchase failed"
    }
    
    // MARK: - Premium Plans
    static var choosePlan: String {
        isArabic ? "اختر خطتك" : "Choose Your Plan"
    }
    
    static var monthly: String {
        isArabic ? "شهري" : "Monthly"
    }
    
    static var yearly: String {
        isArabic ? "سنوي" : "Yearly"
    }
    
    static var save40: String {
        isArabic ? "وفر 40%" : "Save 40%"
    }
    
    static var subscribe: String {
        isArabic ? "اشترك الآن" : "Subscribe Now"
    }
    
    static var perMonth: String {
        isArabic ? "/شهر" : "/month"
    }
    
    static var perYear: String {
        isArabic ? "/سنة" : "/year"
    }
}

// MARK: - Default Info Strings
enum DefaultInfoStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    static var title: String {
        isArabic ? "معلوماتي الافتراضية" : "My Default Info"
    }
    
    static var subtitle: String {
        isArabic ? "هذه المعلومات ستُستخدم لتعبئة السير الذاتية الجديدة تلقائياً" : "This info will be used to auto-fill new CVs"
    }
    
    static var save: String {
        isArabic ? "حفظ المعلومات" : "Save Info"
    }
    
    static var saved: String {
        isArabic ? "تم الحفظ!" : "Saved!"
    }
    
    static var photo: String {
        isArabic ? "صورة شخصية" : "Profile Photo"
    }
    
    static var fullName: String {
        isArabic ? "الاسم الكامل" : "Full Name"
    }
    
    static var email: String {
        isArabic ? "البريد الإلكتروني" : "Email"
    }
    
    static var phone: String {
        isArabic ? "رقم الهاتف" : "Phone"
    }
    
    static var location: String {
        isArabic ? "الموقع" : "Location"
    }
    
    static var website: String {
        isArabic ? "الموقع / LinkedIn" : "Website / LinkedIn"
    }
}
