//
//  LanguageSkill.swift
//  Seerati
//
//  Path: Seerati/Models/LanguageSkill.swift
//

import Foundation
import SwiftData

// MARK: - Language Skill Model
/// نموذج المهارة اللغوية
@Model
final class LanguageSkill {
    
    // MARK: - Properties
    var id: UUID
    
    /// اسم اللغة
    var name: String
    
    /// مستوى الإتقان
    var proficiency: String
    
    /// ترتيب العرض
    var sortOrder: Int
    
    // MARK: - Relationship
    var cv: CVData?
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        name: String = "",
        proficiency: String = "Intermediate",
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.proficiency = proficiency
        self.sortOrder = sortOrder
    }
}

// MARK: - Language Proficiency
enum LanguageProficiency: String, CaseIterable {
    case native = "Native"
    case fluent = "Fluent"
    case advanced = "Advanced"
    case intermediate = "Intermediate"
    case basic = "Basic"
    
    var arabicName: String {
        switch self {
        case .native: return "اللغة الأم"
        case .fluent: return "طلاقة"
        case .advanced: return "متقدم"
        case .intermediate: return "متوسط"
        case .basic: return "أساسي"
        }
    }
}

// MARK: - LanguageSkill Extensions
extension LanguageSkill {
    static var preview: LanguageSkill {
        LanguageSkill(name: "English", proficiency: "Fluent")
    }
}
