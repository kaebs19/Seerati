//
//  CVPreviewStrings.swift
//  Seerati
//
//  Path: Seerati/Features/CVPreview/Resources/CVPreviewStrings.swift
//
//  ─────────────────────────────────────────────
//  AR: النصوص المترجمة لشاشة معاينة السيرة
//  EN: Localized strings for CV Preview screen
//  ─────────────────────────────────────────────

import Foundation

// MARK: - CV Preview Strings
enum CVPreviewStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Navigation
    static var title: String {
        isArabic ? "معاينة السيرة" : "CV Preview"
    }
    
    static var done: String {
        isArabic ? "تم" : "Done"
    }
    
    // MARK: - Actions
    static var exportPDF: String {
        isArabic ? "تصدير PDF" : "Export PDF"
    }
    
    static var share: String {
        isArabic ? "مشاركة" : "Share"
    }
    
    static var edit: String {
        isArabic ? "تعديل" : "Edit"
    }
    
    static var changeTemplate: String {
        isArabic ? "تغيير القالب" : "Change Template"
    }
    
    static var download: String {
        isArabic ? "تحميل" : "Download"
    }
    
    // MARK: - Export
    static var exporting: String {
        isArabic ? "جاري التصدير..." : "Exporting..."
    }
    
    static var exportSuccess: String {
        isArabic ? "تم التصدير بنجاح!" : "Export Successful!"
    }
    
    static var exportFailed: String {
        isArabic ? "فشل التصدير" : "Export Failed"
    }
    
    static var savedToFiles: String {
        isArabic ? "تم الحفظ في الملفات" : "Saved to Files"
    }
    
    // MARK: - Export Limit
    static var exportLimitReached: String {
        isArabic ? "وصلت للحد الأقصى" : "Export Limit Reached"
    }
    
    static var exportLimitMessage: String {
        isArabic ? "لقد استخدمت جميع التصديرات المجانية هذا الشهر. قم بالترقية للتصدير غير المحدود." : "You've used all free exports this month. Upgrade for unlimited exports."
    }
    
    static var upgrade: String {
        isArabic ? "ترقية" : "Upgrade"
    }
    
    // MARK: - Watermark
    static var watermarkNotice: String {
        isArabic ? "سيتم إضافة علامة مائية للنسخة المجانية" : "Watermark will be added for free version"
    }
    
    // MARK: - Template Selection
    static var selectTemplate: String {
        isArabic ? "اختر قالب" : "Select Template"
    }
    
    static var currentTemplate: String {
        isArabic ? "القالب الحالي" : "Current Template"
    }
    
    static var premium: String {
        isArabic ? "مميز" : "Premium"
    }
    
    static var free: String {
        isArabic ? "مجاني" : "Free"
    }
    
    // MARK: - Zoom
    static var zoomIn: String {
        isArabic ? "تكبير" : "Zoom In"
    }
    
    static var zoomOut: String {
        isArabic ? "تصغير" : "Zoom Out"
    }
    
    static var fitToScreen: String {
        isArabic ? "ملائمة الشاشة" : "Fit to Screen"
    }
    
    // MARK: - CV Sections
    static var personalInfo: String {
        isArabic ? "المعلومات الشخصية" : "Personal Information"
    }
    
    static var summary: String {
        isArabic ? "نبذة عني" : "Summary"
    }
    
    static var experience: String {
        isArabic ? "الخبرات العملية" : "Work Experience"
    }
    
    static var education: String {
        isArabic ? "التعليم" : "Education"
    }
    
    static var skills: String {
        isArabic ? "المهارات" : "Skills"
    }
    
    static var languages: String {
        isArabic ? "اللغات" : "Languages"
    }
    
    static var projects: String {
        isArabic ? "المشاريع" : "Projects"
    }
    
    static var certificates: String {
        isArabic ? "الشهادات" : "Certificates"
    }
    
    // MARK: - Empty States
    static var noDataToPreview: String {
        isArabic ? "لا توجد بيانات للمعاينة" : "No data to preview"
    }
    
    static var addInfoFirst: String {
        isArabic ? "أضف معلوماتك أولاً" : "Add your information first"
    }
}
