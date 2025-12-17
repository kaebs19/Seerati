//
//  PersonalInfoStrings.swift
//  Seerati
//
//  Path: Seerati/Features/PersonalInfo/Resources/PersonalInfoStrings.swift
//
//  ─────────────────────────────────────────────
//  AR: النصوص المترجمة لشاشة المعلومات الشخصية
//  EN: Localized strings for Personal Info screen
//  ─────────────────────────────────────────────

import Foundation

// MARK: - Personal Info Strings
enum PersonalInfoStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Navigation
    static var title: String {
        isArabic ? "المعلومات الشخصية" : "PERSONAL INFO"
    }
    
    static var basicInfo: String {
        isArabic ? "المعلومات الأساسية" : "Basic Info"
    }
    
    // MARK: - Header
    static var letsStart: String {
        isArabic ? "لنبدأ بالأساسيات." : "Let's start with the basics."
    }
    
    static var addContactDetails: String {
        isArabic ? "أضف بيانات التواصل ليسهل الوصول إليك." : "Add your contact details so recruiters can reach you easily."
    }
    
    // MARK: - Photo
    static var uploadPhoto: String {
        isArabic ? "رفع صورة" : "Upload Photo"
    }
    
    static var changePhoto: String {
        isArabic ? "تغيير الصورة" : "Change Photo"
    }
    
    static var removePhoto: String {
        isArabic ? "إزالة الصورة" : "Remove Photo"
    }
    
    // MARK: - Fields
    static var fullName: String {
        isArabic ? "الاسم الكامل" : "FULL NAME"
    }
    
    static var fullNamePlaceholder: String {
        isArabic ? "مثال: محمد أحمد" : "e.g. Alex Morgan"
    }
    
    static var professionalTitle: String {
        isArabic ? "المسمى الوظيفي" : "PROFESSIONAL TITLE"
    }
    
    static var professionalTitlePlaceholder: String {
        isArabic ? "مثال: مصمم منتجات" : "e.g. Product Designer"
    }
    
    static var emailAddress: String {
        isArabic ? "البريد الإلكتروني" : "EMAIL ADDRESS"
    }
    
    static var emailPlaceholder: String {
        isArabic ? "example@email.com" : "alex@example.com"
    }
    
    static var phoneNumber: String {
        isArabic ? "رقم الهاتف" : "PHONE NUMBER"
    }
    
    static var phonePlaceholder: String {
        isArabic ? "+966 5X XXX XXXX" : "+1 (555) 000-0000"
    }
    
    static var location: String {
        isArabic ? "الموقع" : "LOCATION"
    }
    
    static var locationPlaceholder: String {
        isArabic ? "المدينة، البلد" : "City, Country"
    }
    
    static var website: String {
        isArabic ? "الموقع / LinkedIn" : "WEBSITE / LINKEDIN"
    }
    
    static var websitePlaceholder: String {
        "https://..."
    }
    
    // MARK: - Button
    static var continueToExperience: String {
        isArabic ? "متابعة للخبرات" : "Continue to Experience"
    }
    
    static var save: String {
        isArabic ? "حفظ" : "Save"
    }
    
    // MARK: - Validation
    static var nameRequired: String {
        isArabic ? "الاسم مطلوب" : "Name is required"
    }
    
    static var invalidEmail: String {
        isArabic ? "البريد الإلكتروني غير صالح" : "Invalid email address"
    }
}
