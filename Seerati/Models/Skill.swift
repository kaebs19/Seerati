//
//  Skill.swift
//  Seerati
//
//  Path: Seerati/Models/Skill.swift
//

import Foundation
import SwiftData

// MARK: - Skill Model
/// نموذج المهارة
@Model
final class Skill {
    
    // MARK: - Properties
    var id: UUID
    
    /// اسم المهارة
    var name: String
    
    /// مستوى المهارة (1-5)
    var level: Int
    
    /// فئة المهارة
    var category: String
    
    /// ترتيب العرض
    var sortOrder: Int
    
    // MARK: - Relationship
    var cv: CVData?
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        name: String = "",
        level: Int = 3,
        category: String = "",
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.level = min(max(level, 1), 5) // Clamp between 1-5
        self.category = category
        self.sortOrder = sortOrder
    }
    
    // MARK: - Computed Properties
    /// نص المستوى
    var levelText: String {
        SkillLevel(rawValue: level)?.name ?? "Intermediate"
    }
    
    /// نص المستوى بالعربية
    var levelTextArabic: String {
        SkillLevel(rawValue: level)?.arabicName ?? "متوسط"
    }
    
    /// نسبة المستوى (للـ Progress Bar)
    var levelPercentage: Double {
        Double(level) / 5.0
    }
}

// MARK: - Skill Level Enum
enum SkillLevel: Int, CaseIterable {
    case beginner = 1
    case elementary = 2
    case intermediate = 3
    case advanced = 4
    case expert = 5
    
    var name: String {
        switch self {
        case .beginner: return "Beginner"
        case .elementary: return "Elementary"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        case .expert: return "Expert"
        }
    }
    
    var arabicName: String {
        switch self {
        case .beginner: return "مبتدئ"
        case .elementary: return "أساسي"
        case .intermediate: return "متوسط"
        case .advanced: return "متقدم"
        case .expert: return "خبير"
        }
    }
}

// MARK: - Skill Category
enum SkillCategory: String, CaseIterable {
    case technical = "Technical"
    case soft = "Soft Skills"
    case language = "Languages"
    case tools = "Tools"
    case other = "Other"
    
    var arabicName: String {
        switch self {
        case .technical: return "تقنية"
        case .soft: return "مهارات شخصية"
        case .language: return "لغات"
        case .tools: return "أدوات"
        case .other: return "أخرى"
        }
    }
}

// MARK: - Skill Extensions
extension Skill {
    static var preview: Skill {
        Skill(name: "Swift", level: 4, category: "Technical")
    }
    
    static var previewList: [Skill] {
        [
            Skill(name: "Swift", level: 5, category: "Technical"),
            Skill(name: "SwiftUI", level: 4, category: "Technical"),
            Skill(name: "UIKit", level: 4, category: "Technical"),
            Skill(name: "Figma", level: 3, category: "Tools"),
            Skill(name: "Git", level: 4, category: "Tools"),
            Skill(name: "Communication", level: 5, category: "Soft Skills")
        ]
    }
}
