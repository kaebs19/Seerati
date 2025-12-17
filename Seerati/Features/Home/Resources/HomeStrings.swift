//
//  HomeStrings.swift
//  Seerati
//
//  Path: Seerati/Features/Home/Resources/HomeStrings.swift
//
//  ─────────────────────────────────────────────
//  AR: النصوص المترجمة لشاشة الرئيسية
//  EN: Localized strings for Home screen
//  ─────────────────────────────────────────────

import Foundation

// MARK: - Home Strings
enum HomeStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Greeting
    static var goodMorning: String {
        isArabic ? "صباح الخير" : "Good morning"
    }
    
    static var goodAfternoon: String {
        isArabic ? "مساء الخير" : "Good afternoon"
    }
    
    static var goodEvening: String {
        isArabic ? "مساء الخير" : "Good evening"
    }
    
    /// التحية حسب الوقت
    static var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return goodMorning
        case 12..<17: return goodAfternoon
        default: return goodEvening
        }
    }
    
    // MARK: - Search
    static var searchPlaceholder: String {
        isArabic ? "ابحث في سيرك الذاتية..." : "Search your CVs..."
    }
    
    // MARK: - Create CV
    static var createNewCV: String {
        isArabic ? "إنشاء سيرة جديدة" : "Create New CV"
    }
    
    static var startFromScratch: String {
        isArabic ? "ابدأ من الصفر أو من قالب" : "Start from scratch or template"
    }
    
    // MARK: - Templates
    static var templates: String {
        isArabic ? "القوالب" : "Templates"
    }
    
    static var viewAll: String {
        isArabic ? "عرض الكل" : "View all"
    }
    
    // MARK: - Recent CVs
    static var recentCVs: String {
        isArabic ? "السير الذاتية الأخيرة" : "Recent CVs"
    }
    
    static var noCVsYet: String {
        isArabic ? "لا توجد سير ذاتية" : "No CVs Yet"
    }
    
    static var createFirstCV: String {
        isArabic ? "أنشئ سيرتك الذاتية الأولى" : "Create your first CV to get started"
    }
    
    // MARK: - Actions
    static var edit: String {
        isArabic ? "تعديل" : "Edit"
    }
    
    static var duplicate: String {
        isArabic ? "نسخ" : "Duplicate"
    }
    
    static var delete: String {
        isArabic ? "حذف" : "Delete"
    }
    
    static var share: String {
        isArabic ? "مشاركة" : "Share"
    }
    
    // MARK: - Time
    static var editedJustNow: String {
        isArabic ? "تم التعديل الآن" : "Edited just now"
    }
    
    static func editedAgo(_ time: String) -> String {
        isArabic ? "تم التعديل \(time)" : "Edited \(time)"
    }
    
    // MARK: - Settings
    static var settings: String {
        isArabic ? "الإعدادات" : "Settings"
    }
}
