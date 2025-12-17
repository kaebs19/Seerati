//
//  HomeViewModel.swift
//  Seerati
//
//  Path: Seerati/Features/Home/ViewModels/HomeViewModel.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة حالة ومنطق الشاشة الرئيسية
//  EN: Home screen state and logic management
//  ─────────────────────────────────────────────

import SwiftUI
import SwiftData

// MARK: - Home ViewModel
@Observable
final class HomeViewModel {
    
    // MARK: - Properties
    
    /// السير الذاتية
    var cvs: [CVData] = []
    
    /// نص البحث
    var searchText: String = ""
    
    /// حالة التحميل
    var isLoading: Bool = false
    
    /// رسالة الخطأ
    var errorMessage: String? = nil
    
    /// إظهار تأكيد الحذف
    var showDeleteConfirmation: Bool = false
    
    /// السيرة المحددة للحذف
    var cvToDelete: CVData? = nil
    
    /// إظهار قائمة الإجراءات
    var showActionSheet: Bool = false
    
    /// السيرة المحددة للإجراءات
    var selectedCV: CVData? = nil
    
    // MARK: - Computed Properties
    
    /// السير الذاتية المفلترة
    var filteredCVs: [CVData] {
        if searchText.isEmpty {
            return cvs
        }
        return cvs.filter { cv in
            cv.cvName.localizedCaseInsensitiveContains(searchText) ||
            cv.fullName.localizedCaseInsensitiveContains(searchText) ||
            cv.jobTitle.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    /// السير الذاتية الأخيرة (5)
    var recentCVs: [CVData] {
        Array(filteredCVs.prefix(5))
    }
    
    /// هل توجد سير ذاتية؟
    var hasCVs: Bool {
        !cvs.isEmpty
    }
    
    // MARK: - Init
    init() {
        loadCVs()
    }
    
    // MARK: - Methods
    
    /// تحميل السير الذاتية
    @MainActor
    func loadCVs() {
        isLoading = true
        errorMessage = nil
        
        do {
            cvs = try DatabaseManager.shared.fetchAllCVs()
            isLoading = false
        } catch {
            errorMessage = "Failed to load CVs: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// تحديث القائمة
    @MainActor
    func refresh() {
        loadCVs()
    }
    
    /// البحث
    func search(query: String) {
        searchText = query
    }
    
    /// مسح البحث
    func clearSearch() {
        searchText = ""
    }
    
    // MARK: - CV Actions
    
    /// تحديد سيرة للإجراءات
    func selectCV(_ cv: CVData) {
        selectedCV = cv
        showActionSheet = true
    }
    
    /// تأكيد حذف سيرة
    func confirmDelete(_ cv: CVData) {
        cvToDelete = cv
        showDeleteConfirmation = true
    }
    
    /// حذف السيرة
    @MainActor
    func deleteCV() {
        guard let cv = cvToDelete else { return }
        
        do {
            try DatabaseManager.shared.deleteCV(cv)
            loadCVs()
            cvToDelete = nil
        } catch {
            errorMessage = "Failed to delete: \(error.localizedDescription)"
        }
    }
    
    /// نسخ سيرة ذاتية
    @MainActor
    func duplicateCV(_ cv: CVData) {
        let newCV = CVData(
            cvName: "\(cv.cvName) (Copy)",
            fullName: cv.fullName,
            jobTitle: cv.jobTitle,
            email: cv.email,
            phone: cv.phone,
            location: cv.location,
            website: cv.website,
            photoData: cv.photoData,
            summary: cv.summary
        )
        
        do {
            try DatabaseManager.shared.createCV(newCV)
            loadCVs()
        } catch {
            errorMessage = "Failed to duplicate: \(error.localizedDescription)"
        }
    }
    
    /// مشاركة سيرة ذاتية
    @MainActor
    func shareCV(_ cv: CVData) {
        PDFManager.shared.exportAndShare(cv: cv, templateId: cv.templateId)
    }
}
