//
//  EducationViewModel.swift
//  Seerati
//
//  Path: Seerati/Features/Education/ViewModels/EducationViewModel.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة حالة ومنطق التعليم
//  EN: Education state and logic management
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Education ViewModel
@Observable
final class EducationViewModel {
    
    // MARK: - Properties
    
    /// السيرة الذاتية
    var cv: CVData
    
    /// قائمة التعليم
    var educations: [Education] {
        cv.educations.sorted { $0.sortOrder < $1.sortOrder }
    }
    
    /// إظهار نموذج الإضافة
    var showAddSheet: Bool = false
    
    /// التعليم المحدد للتعديل
    var educationToEdit: Education? = nil
    
    /// حالة التحميل
    var isLoading: Bool = false
    
    /// رسالة الخطأ
    var errorMessage: String? = nil
    
    // MARK: - Init
    init(cv: CVData) {
        self.cv = cv
    }
    
    // MARK: - Computed
    
    /// هل يوجد تعليم؟
    var hasEducations: Bool {
        !educations.isEmpty
    }
    
    /// عدد التعليم
    var educationCount: Int {
        educations.count
    }
    
    // MARK: - Methods
    
    /// إضافة تعليم جديد
    @MainActor
    func addEducation(_ education: Education) {
        do {
            try DatabaseManager.shared.addEducation(education, to: cv)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// حذف تعليم
    @MainActor
    func deleteEducation(_ education: Education) {
        do {
            try DatabaseManager.shared.deleteEducation(education)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// تعديل تعليم
    func editEducation(_ education: Education) {
        educationToEdit = education
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

// MARK: - Add/Edit Education ViewModel
@Observable
final class AddEducationViewModel {
    
    // MARK: - Properties
    var degree: String = ""
    var institution: String = ""
    var location: String = ""
    var fieldOfStudy: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var isCurrentlyStudying: Bool = false
    var gpa: String = ""
    
    /// التعليم الحالي (للتعديل)
    var existingEducation: Education?
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    // MARK: - Init
    init(education: Education? = nil) {
        if let edu = education {
            self.existingEducation = edu
            self.degree = edu.degree
            self.institution = edu.institution
            self.location = edu.location
            self.fieldOfStudy = edu.fieldOfStudy
            self.startDate = edu.startDate
            self.endDate = edu.endDate ?? Date()
            self.isCurrentlyStudying = edu.isCurrentlyStudying
            self.gpa = edu.gpa
        }
    }
    
    // MARK: - Validation
    
    var isValid: Bool {
        !degree.trimmingCharacters(in: .whitespaces).isEmpty &&
        !institution.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var isEditing: Bool {
        existingEducation != nil
    }
    
    // MARK: - Methods
    
    /// إنشاء أو تحديث التعليم
    func createOrUpdateEducation() -> Education {
        let edu = existingEducation ?? Education()
        
        edu.degree = degree.trimmingCharacters(in: .whitespaces)
        edu.institution = institution.trimmingCharacters(in: .whitespaces)
        edu.location = location.trimmingCharacters(in: .whitespaces)
        edu.fieldOfStudy = fieldOfStudy.trimmingCharacters(in: .whitespaces)
        edu.startDate = startDate
        edu.endDate = isCurrentlyStudying ? nil : endDate
        edu.isCurrentlyStudying = isCurrentlyStudying
        edu.gpa = gpa.trimmingCharacters(in: .whitespaces)
        
        return edu
    }
    
    /// إعادة تعيين
    func reset() {
        degree = ""
        institution = ""
        location = ""
        fieldOfStudy = ""
        startDate = Date()
        endDate = Date()
        isCurrentlyStudying = false
        gpa = ""
        existingEducation = nil
    }
}
