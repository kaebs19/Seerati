//
//  ExperienceViewModel.swift
//  Seerati
//
//  Path: Seerati/Features/Experience/ViewModels/ExperienceViewModel.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة حالة ومنطق الخبرات العملية
//  EN: Experience state and logic management
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Experience ViewModel
@Observable
final class ExperienceViewModel {
    
    // MARK: - Properties
    
    /// السيرة الذاتية
    var cv: CVData
    
    /// قائمة الخبرات
    var experiences: [Experience] {
        cv.experiences.sorted { $0.sortOrder < $1.sortOrder }
    }
    
    /// إظهار نموذج الإضافة
    var showAddSheet: Bool = false
    
    /// الخبرة المحددة للتعديل
    var experienceToEdit: Experience? = nil
    
    /// حالة التحميل
    var isLoading: Bool = false
    
    /// رسالة الخطأ
    var errorMessage: String? = nil
    
    // MARK: - Init
    init(cv: CVData) {
        self.cv = cv
    }
    
    // MARK: - Computed
    
    /// هل توجد خبرات؟
    var hasExperiences: Bool {
        !experiences.isEmpty
    }
    
    /// عدد الخبرات
    var experienceCount: Int {
        experiences.count
    }
    
    // MARK: - Methods
    
    /// إضافة خبرة جديدة
    @MainActor
    func addExperience(_ experience: Experience) {
        do {
            try DatabaseManager.shared.addExperience(experience, to: cv)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// حذف خبرة
    @MainActor
    func deleteExperience(_ experience: Experience) {
        do {
            try DatabaseManager.shared.deleteExperience(experience)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// تعديل خبرة
    func editExperience(_ experience: Experience) {
        experienceToEdit = experience
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
}

// MARK: - Add/Edit Experience ViewModel
@Observable
final class AddExperienceViewModel {
    
    // MARK: - Properties
    var jobTitle: String = ""
    var company: String = ""
    var location: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var isCurrentJob: Bool = false
    var jobDescription: String = ""
    
    /// الخبرة الحالية (للتعديل)
    var existingExperience: Experience?
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    // MARK: - Init
    init(experience: Experience? = nil) {
        if let exp = experience {
            self.existingExperience = exp
            self.jobTitle = exp.jobTitle
            self.company = exp.company
            self.location = exp.location
            self.startDate = exp.startDate
            self.endDate = exp.endDate ?? Date()
            self.isCurrentJob = exp.isCurrentJob
            self.jobDescription = exp.jobDescription
        }
    }
    
    // MARK: - Validation
    
    var isValid: Bool {
        !jobTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
        !company.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var isEditing: Bool {
        existingExperience != nil
    }
    
    // MARK: - Methods
    
    /// إنشاء أو تحديث الخبرة
    func createOrUpdateExperience() -> Experience {
        let exp = existingExperience ?? Experience()
        
        exp.jobTitle = jobTitle.trimmingCharacters(in: .whitespaces)
        exp.company = company.trimmingCharacters(in: .whitespaces)
        exp.location = location.trimmingCharacters(in: .whitespaces)
        exp.startDate = startDate
        exp.endDate = isCurrentJob ? nil : endDate
        exp.isCurrentJob = isCurrentJob
        exp.jobDescription = jobDescription.trimmingCharacters(in: .whitespaces)
        
        return exp
    }
    
    /// إعادة تعيين
    func reset() {
        jobTitle = ""
        company = ""
        location = ""
        startDate = Date()
        endDate = Date()
        isCurrentJob = false
        jobDescription = ""
        existingExperience = nil
    }
}
