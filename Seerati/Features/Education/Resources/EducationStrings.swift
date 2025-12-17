//
//  EducationStrings.swift
//  Seerati
//
//  Path: Seerati/Features/Education/Resources/EducationStrings.swift
//
//  ─────────────────────────────────────────────
//  AR: النصوص المترجمة لشاشة التعليم
//  EN: Localized strings for Education screen
//  ─────────────────────────────────────────────

import Foundation

// MARK: - Education Strings
enum EducationStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Navigation
    static var title: String {
        isArabic ? "التعليم" : "EDUCATION"
    }
    
    // MARK: - Header
    static var shareEducation: String {
        isArabic ? "شارك مؤهلاتك التعليمية." : "Share your education background."
    }
    
    static var educationDescription: String {
        isArabic ? "أضف شهاداتك ودرجاتك العلمية." : "Add your degrees and academic achievements."
    }
    
    // MARK: - Empty State
    static var noEducation: String {
        isArabic ? "لا يوجد تعليم" : "No Education Yet"
    }
    
    static var addFirstEducation: String {
        isArabic ? "أضف مؤهلك التعليمي الأول" : "Add your first education entry"
    }
    
    // MARK: - Actions
    static var addEducation: String {
        isArabic ? "إضافة تعليم" : "Add Education"
    }
    
    static var editEducation: String {
        isArabic ? "تعديل التعليم" : "Edit Education"
    }
    
    static var deleteEducation: String {
        isArabic ? "حذف التعليم" : "Delete Education"
    }
    
    // MARK: - Form Fields
    static var degree: String {
        isArabic ? "الدرجة العلمية" : "DEGREE"
    }
    
    static var degreePlaceholder: String {
        isArabic ? "مثال: بكالوريوس علوم حاسب" : "e.g. Bachelor of Computer Science"
    }
    
    static var institution: String {
        isArabic ? "المؤسسة التعليمية" : "INSTITUTION"
    }
    
    static var institutionPlaceholder: String {
        isArabic ? "مثال: جامعة الملك سعود" : "e.g. Stanford University"
    }
    
    static var location: String {
        isArabic ? "الموقع" : "LOCATION"
    }
    
    static var locationPlaceholder: String {
        isArabic ? "مثال: الرياض، السعودية" : "e.g. California, USA"
    }
    
    static var startDate: String {
        isArabic ? "تاريخ البداية" : "START DATE"
    }
    
    static var endDate: String {
        isArabic ? "تاريخ التخرج" : "END DATE"
    }
    
    static var currentlyStudying: String {
        isArabic ? "أدرس حالياً" : "Currently studying here"
    }
    
    static var present: String {
        isArabic ? "حتى الآن" : "Present"
    }
    
    static var gpa: String {
        isArabic ? "المعدل التراكمي" : "GPA"
    }
    
    static var gpaPlaceholder: String {
        isArabic ? "مثال: 3.8 / 4.0" : "e.g. 3.8 / 4.0"
    }
    
    static var fieldOfStudy: String {
        isArabic ? "التخصص" : "FIELD OF STUDY"
    }
    
    static var fieldOfStudyPlaceholder: String {
        isArabic ? "مثال: هندسة البرمجيات" : "e.g. Software Engineering"
    }
    
    // MARK: - Buttons
    static var save: String {
        isArabic ? "حفظ" : "Save"
    }
    
    static var continueToSkills: String {
        isArabic ? "متابعة للمهارات" : "Continue to Skills"
    }
    
    static var skip: String {
        isArabic ? "تخطي" : "Skip"
    }
}
