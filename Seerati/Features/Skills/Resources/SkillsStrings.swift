//
//  SkillsStrings.swift
//  Seerati
//
//  Path: Seerati/Features/Skills/Resources/SkillsStrings.swift
//
//  ─────────────────────────────────────────────
//  AR: النصوص المترجمة لشاشة المهارات
//  EN: Localized strings for Skills screen
//  ─────────────────────────────────────────────

import Foundation

// MARK: - Skills Strings
enum SkillsStrings {
    
    private static var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Navigation
    static var title: String {
        isArabic ? "المهارات" : "SKILLS"
    }
    
    // MARK: - Header
    static var highlightSkills: String {
        isArabic ? "أبرز مهاراتك." : "Highlight your skills."
    }
    
    static var skillsDescription: String {
        isArabic ? "أضف مهاراتك التقنية والشخصية." : "Add your technical and soft skills."
    }
    
    // MARK: - Empty State
    static var noSkills: String {
        isArabic ? "لا توجد مهارات" : "No Skills Yet"
    }
    
    static var addFirstSkill: String {
        isArabic ? "أضف مهارتك الأولى" : "Add your first skill"
    }
    
    // MARK: - Categories
    static var technicalSkills: String {
        isArabic ? "المهارات التقنية" : "Technical Skills"
    }
    
    static var softSkills: String {
        isArabic ? "المهارات الشخصية" : "Soft Skills"
    }
    
    static var languageSkills: String {
        isArabic ? "اللغات" : "Languages"
    }
    
    static var otherSkills: String {
        isArabic ? "مهارات أخرى" : "Other Skills"
    }
    
    // MARK: - Actions
    static var addSkill: String {
        isArabic ? "إضافة مهارة" : "Add Skill"
    }
    
    static var editSkill: String {
        isArabic ? "تعديل المهارة" : "Edit Skill"
    }
    
    static var deleteSkill: String {
        isArabic ? "حذف المهارة" : "Delete Skill"
    }
    
    // MARK: - Form Fields
    static var skillName: String {
        isArabic ? "اسم المهارة" : "SKILL NAME"
    }
    
    static var skillNamePlaceholder: String {
        isArabic ? "مثال: Swift" : "e.g. Swift"
    }
    
    static var category: String {
        isArabic ? "الفئة" : "CATEGORY"
    }
    
    static var proficiencyLevel: String {
        isArabic ? "مستوى الإتقان" : "PROFICIENCY LEVEL"
    }
    
    // MARK: - Proficiency Levels
    static var beginner: String {
        isArabic ? "مبتدئ" : "Beginner"
    }
    
    static var intermediate: String {
        isArabic ? "متوسط" : "Intermediate"
    }
    
    static var advanced: String {
        isArabic ? "متقدم" : "Advanced"
    }
    
    static var expert: String {
        isArabic ? "خبير" : "Expert"
    }
    
    // MARK: - Buttons
    static var save: String {
        isArabic ? "حفظ" : "Save"
    }
    
    static var previewCV: String {
        isArabic ? "معاينة السيرة" : "Preview CV"
    }
    

    
    static var skip: String {
        isArabic ? "تخطي" : "Skip"
    }
    
    static var finish: String {
        isArabic ? "إنهاء" : "Finish"
    }
    
    // MARK: - Suggestions
    static var suggestions: String {
        isArabic ? "اقتراحات" : "Suggestions"
    }
    
    static var popularSkills: String {
        isArabic ? "مهارات شائعة" : "Popular Skills"
    }
}

// MARK: - Proficiency Level (for UI)
enum ProficiencyLevel: Int, CaseIterable, Identifiable {
    case beginner = 1
    case elementary = 2
    case intermediate = 3
    case advanced = 4
    case expert = 5
    
    var id: Int { rawValue }
    
    var displayName: String {
        let isArabic = LocalizationManager.shared.isArabic
        switch self {
        case .beginner: return isArabic ? "مبتدئ" : "Beginner"
        case .elementary: return isArabic ? "أساسي" : "Elementary"
        case .intermediate: return isArabic ? "متوسط" : "Intermediate"
        case .advanced: return isArabic ? "متقدم" : "Advanced"
        case .expert: return isArabic ? "خبير" : "Expert"
        }
    }
    
    var percentage: Double {
        Double(rawValue) / 5.0
    }
}
