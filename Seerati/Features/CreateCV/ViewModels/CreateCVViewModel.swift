//
//  CreateCVViewModel.swift
//  Seerati
//
//  Path: Seerati/Features/CreateCV/ViewModels/CreateCVViewModel.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة حالة ومنطق إنشاء سيرة جديدة
//  EN: State and logic for creating new CV
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Create CV ViewModel
@Observable
final class CreateCVViewModel {
    
    // MARK: - Properties
    
    /// اسم السيرة الذاتية
    var cvName: String = ""
    
    /// حالة التحميل
    var isLoading: Bool = false
    
    /// رسالة الخطأ
    var errorMessage: String? = nil
    
    /// هل تم الإنشاء بنجاح؟
    var isCreated: Bool = false
    
    /// السيرة المُنشأة
    var createdCV: CVData? = nil
    
    // MARK: - Validation
    
    /// هل الاسم صالح؟
    var isNameValid: Bool {
        cvName.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }
    
    /// هل يمكن المتابعة؟
    var canProceed: Bool {
        isNameValid && !isLoading
    }
    
    /// رسالة التحقق
    var validationMessage: String? {
        if cvName.isEmpty {
            return nil
        }
        if cvName.count < 2 {
            return CreateCVStrings.nameTooShort
        }
        return nil
    }
    
    // MARK: - Methods
    
    /// إنشاء السيرة الذاتية
    @MainActor
    func createCV() {
        guard isNameValid else {
            errorMessage = CreateCVStrings.nameRequired
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let cv = try DatabaseManager.shared.createEmptyCV(name: cvName.trimmingCharacters(in: .whitespacesAndNewlines))
            createdCV = cv
            isCreated = true
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    /// إعادة تعيين
    func reset() {
        cvName = ""
        isLoading = false
        errorMessage = nil
        isCreated = false
        createdCV = nil
    }
}
