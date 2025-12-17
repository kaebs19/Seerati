//
//  ExperienceStrings.swift
//  Seerati
//
//  Path: Seerati/Features/Experience/Resources/ExperienceStrings.swift
//
//  ─────────────────────────────────────────────
//  AR: النصوص المترجمة لشاشة الخبرات العملية
//  EN: Localized strings for Experience screen
//  ─────────────────────────────────────────────

import Foundation

// MARK: - Experience Strings
enum ExperienceStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Navigation
    static var title: String {
        isArabic ? "الخبرات العملية" : "EXPERIENCE"
    }
    
    // MARK: - Header
    static var shareExperience: String {
        isArabic ? "شارك خبراتك العملية." : "Share your work experience."
    }
    
    static var experienceDescription: String {
        isArabic ? "أضف وظائفك السابقة والحالية." : "Add your current and previous positions."
    }
    
    // MARK: - Empty State
    static var noExperience: String {
        isArabic ? "لا توجد خبرات" : "No Experience Yet"
    }
    
    static var addFirstExperience: String {
        isArabic ? "أضف خبرتك العملية الأولى" : "Add your first work experience"
    }
    
    // MARK: - Actions
    static var addExperience: String {
        isArabic ? "إضافة خبرة" : "Add Experience"
    }
    
    static var editExperience: String {
        isArabic ? "تعديل الخبرة" : "Edit Experience"
    }
    
    static var deleteExperience: String {
        isArabic ? "حذف الخبرة" : "Delete Experience"
    }
    
    // MARK: - Form Fields
    static var jobTitle: String {
        isArabic ? "المسمى الوظيفي" : "JOB TITLE"
    }
    
    static var jobTitlePlaceholder: String {
        isArabic ? "مثال: مطور iOS" : "e.g. iOS Developer"
    }
    
    static var company: String {
        isArabic ? "الشركة" : "COMPANY"
    }
    
    static var companyPlaceholder: String {
        isArabic ? "مثال: شركة التقنية" : "e.g. Tech Corp"
    }
    
    static var location: String {
        isArabic ? "الموقع" : "LOCATION"
    }
    
    static var locationPlaceholder: String {
        isArabic ? "مثال: الرياض، السعودية" : "e.g. San Francisco, CA"
    }
    
    static var startDate: String {
        isArabic ? "تاريخ البداية" : "START DATE"
    }
    
    static var endDate: String {
        isArabic ? "تاريخ النهاية" : "END DATE"
    }
    
    static var currentlyWorking: String {
        isArabic ? "أعمل هنا حالياً" : "I currently work here"
    }
    
    static var present: String {
        isArabic ? "حتى الآن" : "Present"
    }
    
    static var description: String {
        isArabic ? "الوصف" : "DESCRIPTION"
    }
    
    static var descriptionPlaceholder: String {
        isArabic ? "صف مهامك وإنجازاتك..." : "Describe your responsibilities and achievements..."
    }
    
    // MARK: - Buttons
    static var save: String {
        isArabic ? "حفظ" : "Save"
    }
    
    static var continueToEducation: String {
        isArabic ? "متابعة للتعليم" : "Continue to Education"
    }
    
    static var skip: String {
        isArabic ? "تخطي" : "Skip"
    }
}
