//
//  ScreensStrings.swift
//  Seerati
//
//  Path: Seerati/Core/Localization/ScreensStrings.swift
//
//  ─────────────────────────────────────────────────────
//  AR: نصوص الشاشات الجديدة
//  EN: New Screens Strings
//  ─────────────────────────────────────────────────────

import Foundation

// MARK: - My CVs Strings
enum MyCVsStrings {
    static var title: String {
        LocalizationManager.shared.isArabic ? "سيرتي الذاتية" : "My CVs"
    }
    
    static var searchPlaceholder: String {
        LocalizationManager.shared.isArabic ? "البحث في السير الذاتية" : "Search CVs"
    }
    
    static var noCVs: String {
        LocalizationManager.shared.isArabic ? "لا توجد سير ذاتية" : "No CVs yet"
    }
    
    static var createFirst: String {
        LocalizationManager.shared.isArabic ? "ابدأ بإنشاء سيرتك الذاتية الأولى" : "Start by creating your first CV"
    }
    
    static var createCV: String {
        LocalizationManager.shared.isArabic ? "إنشاء سيرة ذاتية" : "Create CV"
    }
    
    static var preview: String {
        LocalizationManager.shared.isArabic ? "معاينة" : "Preview"
    }
    
    static var edit: String {
        LocalizationManager.shared.isArabic ? "تعديل" : "Edit"
    }
    
    static var duplicate: String {
        LocalizationManager.shared.isArabic ? "نسخ" : "Duplicate"
    }
    
    static var delete: String {
        LocalizationManager.shared.isArabic ? "حذف" : "Delete"
    }
    
    static var deleteTitle: String {
        LocalizationManager.shared.isArabic ? "حذف السيرة الذاتية" : "Delete CV"
    }
    
    static var deleteMessage: String {
        LocalizationManager.shared.isArabic ? "هل أنت متأكد من حذف هذه السيرة الذاتية؟ لا يمكن التراجع عن هذا الإجراء." : "Are you sure you want to delete this CV? This action cannot be undone."
    }
    
    static var cancel: String {
        LocalizationManager.shared.isArabic ? "إلغاء" : "Cancel"
    }
    
    static var done: String {
        LocalizationManager.shared.isArabic ? "تم" : "Done"
    }
    
    static var newCV: String {
        LocalizationManager.shared.isArabic ? "سيرة ذاتية جديدة" : "New CV"
    }
    
    static var cvName: String {
        LocalizationManager.shared.isArabic ? "اسم السيرة الذاتية" : "CV Name"
    }
    
    static var cvNamePlaceholder: String {
        LocalizationManager.shared.isArabic ? "مثال: وظيفة مطور iOS" : "e.g., iOS Developer Position"
    }
    
    static var create: String {
        LocalizationManager.shared.isArabic ? "إنشاء" : "Create"
    }
    
    static var copy: String {
        LocalizationManager.shared.isArabic ? "نسخة" : "Copy"
    }
}

// MARK: - Profile Strings
enum ProfileStrings {
    static var title: String {
        LocalizationManager.shared.isArabic ? "الملف الشخصي" : "Profile"
    }
    
    static var save: String {
        LocalizationManager.shared.isArabic ? "حفظ" : "Save"
    }
    
    static var done: String {
        LocalizationManager.shared.isArabic ? "تم" : "Done"
    }
    
    static var changePhoto: String {
        LocalizationManager.shared.isArabic ? "تغيير الصورة" : "Change Photo"
    }
    
    static var addPhoto: String {
        LocalizationManager.shared.isArabic ? "إضافة صورة" : "Add Photo"
    }
    
    static var fullName: String {
        LocalizationManager.shared.isArabic ? "الاسم الكامل" : "Full Name"
    }
    
    static var fullNamePlaceholder: String {
        LocalizationManager.shared.isArabic ? "أدخل اسمك الكامل" : "Enter your full name"
    }
    
    static var jobTitle: String {
        LocalizationManager.shared.isArabic ? "المسمى الوظيفي" : "Job Title"
    }
    
    static var jobTitlePlaceholder: String {
        LocalizationManager.shared.isArabic ? "مثال: مطور iOS" : "e.g., iOS Developer"
    }
    
    static var email: String {
        LocalizationManager.shared.isArabic ? "البريد الإلكتروني" : "Email"
    }
    
    static var phone: String {
        LocalizationManager.shared.isArabic ? "رقم الهاتف" : "Phone"
    }
    
    static var location: String {
        LocalizationManager.shared.isArabic ? "الموقع" : "Location"
    }
    
    static var locationPlaceholder: String {
        LocalizationManager.shared.isArabic ? "المدينة، البلد" : "City, Country"
    }
    
    static var website: String {
        LocalizationManager.shared.isArabic ? "الموقع / LinkedIn" : "Website / LinkedIn"
    }
    
    static var statistics: String {
        LocalizationManager.shared.isArabic ? "الإحصائيات" : "Statistics"
    }
    
    static var cvsCreated: String {
        LocalizationManager.shared.isArabic ? "سيرة ذاتية" : "CVs"
    }
    
    static var exports: String {
        LocalizationManager.shared.isArabic ? "تصدير" : "Exports"
    }
    
    static var savedTitle: String {
        LocalizationManager.shared.isArabic ? "تم الحفظ" : "Saved"
    }
    
    static var savedMessage: String {
        LocalizationManager.shared.isArabic ? "تم حفظ معلومات الملف الشخصي بنجاح" : "Profile information saved successfully"
    }
    
    static var ok: String {
        LocalizationManager.shared.isArabic ? "حسناً" : "OK"
    }
}

// MARK: - About Strings
enum AboutStrings {
    static var title: String {
        LocalizationManager.shared.isArabic ? "عن التطبيق" : "About"
    }
    
    static var appName: String {
        "سيرتي"
    }
    
    static var appNameEn: String {
        "Seerati"
    }
    
    static var version: String {
        LocalizationManager.shared.isArabic ? "الإصدار" : "Version"
    }
    
    static var description: String {
        LocalizationManager.shared.isArabic
            ? "تطبيق سيرتي هو أفضل تطبيق لإنشاء السير الذاتية الاحترافية باللغة العربية والإنجليزية. صمم سيرتك الذاتية بسهولة واحترافية."
            : "Seerati is the best app for creating professional CVs in Arabic and English. Design your CV easily and professionally."
    }
    
    static var feature1: String {
        LocalizationManager.shared.isArabic ? "قوالب احترافية متعددة" : "Multiple professional templates"
    }
    
    static var feature2: String {
        LocalizationManager.shared.isArabic ? "دعم العربية والإنجليزية" : "Arabic and English support"
    }
    
    static var feature3: String {
        LocalizationManager.shared.isArabic ? "تصدير PDF عالي الجودة" : "High quality PDF export"
    }
    
    static var feature4: String {
        LocalizationManager.shared.isArabic ? "خصوصية تامة - بياناتك على جهازك" : "Complete privacy - data stays on your device"
    }
    
    static var rateUs: String {
        LocalizationManager.shared.isArabic ? "قيّمنا" : "Rate Us"
    }
    
    static var share: String {
        LocalizationManager.shared.isArabic ? "شارك" : "Share"
    }
    
    static var contact: String {
        LocalizationManager.shared.isArabic ? "تواصل" : "Contact"
    }
    
    static var copyright: String {
        LocalizationManager.shared.isArabic ? "© 2024 سيرتي. جميع الحقوق محفوظة." : "© 2024 Seerati. All rights reserved."
    }
}

// MARK: - Common Strings
enum CommonStrings {
    static var done: String {
        LocalizationManager.shared.isArabic ? "تم" : "Done"
    }
    
    static var cancel: String {
        LocalizationManager.shared.isArabic ? "إلغاء" : "Cancel"
    }
    
    static var save: String {
        LocalizationManager.shared.isArabic ? "حفظ" : "Save"
    }
    
    static var delete: String {
        LocalizationManager.shared.isArabic ? "حذف" : "Delete"
    }
    
    static var edit: String {
        LocalizationManager.shared.isArabic ? "تعديل" : "Edit"
    }
    
    static var retry: String {
        LocalizationManager.shared.isArabic ? "إعادة المحاولة" : "Retry"
    }
    
    static var loading: String {
        LocalizationManager.shared.isArabic ? "جاري التحميل..." : "Loading..."
    }
    
    static var error: String {
        LocalizationManager.shared.isArabic ? "خطأ" : "Error"
    }
    
    static var loadError: String {
        LocalizationManager.shared.isArabic ? "تعذر تحميل الصفحة" : "Failed to load page"
    }
}
