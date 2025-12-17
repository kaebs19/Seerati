//
//  PersonalInfoViewModel.swift
//  Seerati
//
//  Path: Seerati/Features/PersonalInfo/ViewModels/PersonalInfoViewModel.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة حالة ومنطق المعلومات الشخصية
//  EN: Personal info state and logic management
//  ─────────────────────────────────────────────

import SwiftUI
import PhotosUI

// MARK: - Personal Info ViewModel
@Observable
final class PersonalInfoViewModel {
    
    // MARK: - Properties
    
    /// السيرة الذاتية
    var cv: CVData
    
    /// الاسم الكامل
    var fullName: String
    
    /// المسمى الوظيفي
    var jobTitle: String
    
    /// البريد الإلكتروني
    var email: String
    
    /// رقم الهاتف
    var phone: String
    
    /// الموقع
    var location: String
    
    /// الموقع الإلكتروني
    var website: String
    
    /// بيانات الصورة
    var photoData: Data?
    
    /// عنصر الصورة المحدد
    var selectedPhotoItem: PhotosPickerItem?
    
    /// حالة التحميل
    var isLoading: Bool = false
    
    /// حالة حفظ
    var isSaving: Bool = false
    
    /// رسالة الخطأ
    var errorMessage: String? = nil
    
    /// تم الحفظ بنجاح
    var isSaved: Bool = false
    
    /// إظهار خيارات الصورة
    var showPhotoOptions: Bool = false
    
    // MARK: - Init
    init(cv: CVData) {
        self.cv = cv
        self.fullName = cv.fullName
        self.jobTitle = cv.jobTitle
        self.email = cv.email
        self.phone = cv.phone
        self.location = cv.location
        self.website = cv.website
        self.photoData = cv.photoData
    }
    
    // MARK: - Validation
    
    /// هل الاسم صالح؟
    var isNameValid: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// هل البريد صالح؟
    var isEmailValid: Bool {
        email.isEmpty || email.contains("@")
    }
    
    /// هل يمكن المتابعة؟
    var canProceed: Bool {
        isNameValid && isEmailValid && !isSaving
    }
    
    /// نسبة الاكتمال
    var completionPercentage: Int {
        var filled = 0
        let total = 6
        
        if !fullName.isEmpty { filled += 1 }
        if !jobTitle.isEmpty { filled += 1 }
        if !email.isEmpty { filled += 1 }
        if !phone.isEmpty { filled += 1 }
        if !location.isEmpty { filled += 1 }
        if photoData != nil { filled += 1 }
        
        return (filled * 100) / total
    }
    
    // MARK: - Photo
    
    /// تحميل الصورة المحددة
    @MainActor
    func loadPhoto() async {
        guard let item = selectedPhotoItem else { return }
        
        isLoading = true
        
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                // ضغط الصورة
                if let uiImage = UIImage(data: data),
                   let compressed = uiImage.jpegData(compressionQuality: 0.7) {
                    photoData = compressed
                } else {
                    photoData = data
                }
            }
        } catch {
            errorMessage = "Failed to load photo"
        }
        
        isLoading = false
    }
    
    /// إزالة الصورة
    func removePhoto() {
        photoData = nil
        selectedPhotoItem = nil
    }
    
    // MARK: - Save
    
    /// حفظ البيانات
    @MainActor
    func save() {
        guard canProceed else {
            if !isNameValid {
                errorMessage = PersonalInfoStrings.nameRequired
            }
            return
        }
        
        isSaving = true
        errorMessage = nil
        
        // تحديث بيانات السيرة
        cv.fullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        cv.jobTitle = jobTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        cv.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        cv.phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        cv.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        cv.website = website.trimmingCharacters(in: .whitespacesAndNewlines)
        cv.photoData = photoData
        
        do {
            try DatabaseManager.shared.updateCV(cv)
            isSaved = true
            
            // حفظ للاستخدام السريع
            UserDefaultsManager.shared.saveUserInfo(
                name: cv.fullName,
                email: cv.email,
                phone: cv.phone,
                photo: cv.photoData
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isSaving = false
    }
    
    /// تعبئة تلقائية من البيانات المحفوظة
    func autoFill() {
        let defaults = UserDefaultsManager.shared
        
        if fullName.isEmpty, let name = defaults.userName {
            fullName = name
        }
        if email.isEmpty, let savedEmail = defaults.userEmail {
            email = savedEmail
        }
        if phone.isEmpty, let savedPhone = defaults.userPhone {
            phone = savedPhone
        }
        if photoData == nil, let savedPhoto = defaults.userPhotoData {
            photoData = savedPhoto
        }
    }
}
