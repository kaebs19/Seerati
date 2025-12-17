//
//  SkillsViewModel.swift
//  Seerati
//
//  Path: Seerati/Features/Skills/ViewModels/SkillsViewModel.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة حالة ومنطق المهارات
//  EN: Skills state and logic management
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Skills ViewModel
@Observable
final class SkillsViewModel {
    
    // MARK: - Properties
    
    /// السيرة الذاتية
    var cv: CVData
    
    /// قائمة المهارات
    var skills: [Skill] {
        cv.skills.sorted { $0.sortOrder < $1.sortOrder }
    }
    
    /// المهارات التقنية
    var technicalSkills: [Skill] {
        skills.filter { $0.category == SkillCategory.technical.rawValue }
    }
    
    /// المهارات الشخصية
    var softSkills: [Skill] {
        skills.filter { $0.category == SkillCategory.soft.rawValue }
    }
    
    /// اللغات
    var languageSkills: [Skill] {
        skills.filter { $0.category == SkillCategory.language.rawValue }
    }
    
    /// الأدوات
    var toolsSkills: [Skill] {
        skills.filter { $0.category == SkillCategory.tools.rawValue }
    }
    
    /// مهارات أخرى
    var otherSkills: [Skill] {
        skills.filter { $0.category == SkillCategory.other.rawValue }
    }
    
    /// إظهار نموذج الإضافة
    var showAddSheet: Bool = false
    
    /// المهارة المحددة للتعديل
    var skillToEdit: Skill? = nil
    
    /// حالة التحميل
    var isLoading: Bool = false
    
    /// رسالة الخطأ
    var errorMessage: String? = nil
    
    // MARK: - Init
    init(cv: CVData) {
        self.cv = cv
    }
    
    // MARK: - Computed
    
    /// هل توجد مهارات؟
    var hasSkills: Bool {
        !skills.isEmpty
    }
    
    /// عدد المهارات
    var skillsCount: Int {
        skills.count
    }
    
    // MARK: - Methods
    
    /// إضافة مهارة جديدة
    @MainActor
    func addSkill(_ skill: Skill) {
        do {
            try DatabaseManager.shared.addSkill(skill, to: cv)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// حذف مهارة
    @MainActor
    func deleteSkill(_ skill: Skill) {
        do {
            try DatabaseManager.shared.deleteSkill(skill)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// تعديل مهارة
    func editSkill(_ skill: Skill) {
        skillToEdit = skill
        showAddSheet = true
    }
    
    /// حفظ التعديلات
    @MainActor
    func saveChanges() {
        do {
            try DatabaseManager.shared.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// إضافة مهارة سريعة من الاقتراحات
    @MainActor
    func addQuickSkill(name: String, category: SkillCategory, level: Int = 3) {
        let skill = Skill(
            name: name,
            level: level,
            category: category.rawValue,
            sortOrder: skills.count
        )
        addSkill(skill)
    }
}

// MARK: - Add/Edit Skill ViewModel
@Observable
final class AddSkillViewModel {
    
    // MARK: - Properties
    var name: String = ""
    var level: Int = 3
    var category: SkillCategory = .technical
    
    /// المهارة الحالية (للتعديل)
    var existingSkill: Skill?
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    // MARK: - Init
    init(skill: Skill? = nil) {
        if let skill = skill {
            self.existingSkill = skill
            self.name = skill.name
            self.level = skill.level
            self.category = SkillCategory(rawValue: skill.category) ?? .technical
        }
    }
    
    // MARK: - Validation
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var isEditing: Bool {
        existingSkill != nil
    }
    
    // MARK: - Methods
    
    /// إنشاء أو تحديث المهارة
    func createOrUpdateSkill() -> Skill {
        let skill = existingSkill ?? Skill()
        
        skill.name = name.trimmingCharacters(in: .whitespaces)
        skill.level = level
        skill.category = category.rawValue
        
        return skill
    }
    
    /// إعادة تعيين
    func reset() {
        name = ""
        level = 3
        category = .technical
        existingSkill = nil
    }
}

// MARK: - Skill Suggestions
struct SkillSuggestions {
    
    static let technical = [
        "Swift", "SwiftUI", "UIKit", "Python", "JavaScript",
        "React", "Node.js", "SQL", "Git", "REST APIs",
        "Core Data", "Firebase", "AWS", "Docker", "Kubernetes"
    ]
    
    static let soft = [
        "Communication", "Leadership", "Problem Solving",
        "Team Work", "Time Management", "Critical Thinking",
        "Creativity", "Adaptability", "Project Management"
    ]
    
    static let tools = [
        "Xcode", "VS Code", "Figma", "Sketch", "Jira",
        "Slack", "Notion", "Postman", "Terminal", "GitHub"
    ]
    
    static let languages = [
        "Arabic", "English", "French", "Spanish",
        "German", "Chinese", "Japanese", "Korean"
    ]
}
