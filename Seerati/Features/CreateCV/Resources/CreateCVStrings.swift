//
//  CreateCVStrings.swift
//  Seerati
//
//  Path: Seerati/Features/CreateCV/Resources/CreateCVStrings.swift
//
//  ─────────────────────────────────────────────
//  AR: النصوص المترجمة لشاشة إنشاء سيرة جديدة
//  EN: Localized strings for Create CV screen
//  ─────────────────────────────────────────────

import Foundation

// MARK: - Create CV Strings
enum CreateCVStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Navigation
    static var newCV: String {
        isArabic ? "سيرة جديدة" : "New CV"
    }
    
    static var cancel: String {
        isArabic ? "إلغاء" : "Cancel"
    }
    
    // MARK: - Title
    static var whatShouldWeCall: String {
        isArabic ? "ماذا نسمي هذه السيرة؟" : "What should we call this CV?"
    }
    
    static var justForReference: String {
        isArabic ? "هذا للمرجع فقط. لن يراه المسؤولون." : "This is just for your reference. Recruiters won't see this name."
    }
    
    // MARK: - Input
    static var cvName: String {
        isArabic ? "اسم السيرة" : "CV NAME"
    }
    
    static var cvNamePlaceholder: String {
        isArabic ? "مثال: سيرة التسويق 2024" : "e.g. Marketing Resume 2024"
    }
    
    // MARK: - Button
    static var createAndContinue: String {
        isArabic ? "إنشاء ومتابعة" : "Create & Continue"
    }
    
    // MARK: - Validation
    static var nameRequired: String {
        isArabic ? "الرجاء إدخال اسم للسيرة" : "Please enter a name for your CV"
    }
    
    static var nameTooShort: String {
        isArabic ? "الاسم قصير جداً" : "Name is too short"
    }
}
