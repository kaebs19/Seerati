//
//  CVPreviewViewModel.swift
//  Seerati
//
//  Path: Seerati/Features/CVPreview/ViewModels/CVPreviewViewModel.swift
//
//  ─────────────────────────────────────────────────
//  AR: إدارة حالة ومنطق معاينة السيرة - محدث
//  EN: CV Preview state and logic management - Updated
//  ─────────────────────────────────────────────────

import SwiftUI
import PDFKit

// MARK: - CV Preview ViewModel
@Observable
final class CVPreviewViewModel {
    
    // MARK: - Properties
    
    /// السيرة الذاتية
    var cv: CVData
    
    /// القالب المحدد
    var selectedTemplate: Template
    
    /// مقياس العرض
    var scale: CGFloat = 0.55
    
    /// حالة التصدير
    var isExporting: Bool = false
    
    /// إظهار نجاح التصدير
    var showExportSuccess: Bool = false
    
    /// إظهار خطأ التصدير
    var showExportError: Bool = false
    
    /// رسالة الخطأ
    var errorMessage: String = ""
    
    /// إظهار حد التصدير
    var showExportLimitAlert: Bool = false
    
    /// إظهار اختيار القوالب
    var showTemplateSelector: Bool = false
    
    /// إظهار صفحة Premium
    var showPremiumPage: Bool = false
    
    /// إظهار تنبيه القالب المقفل
    var showTemplateLocked: Bool = false
    
    /// PDF المُنشأ
    var generatedPDFData: Data?
    
    /// URL الملف المحفوظ
    var savedPDFURL: URL?
    
    /// إظهار Share Sheet
    var showShareSheet: Bool = false
    
    // MARK: - Managers
    let purchaseManager = PurchaseManager.shared
    private let pdfService = PDFExportService.shared
    
    // MARK: - Init
    init(cv: CVData, template: Template? = nil) {
        self.cv = cv
        
        // تحديد القالب الافتراضي
        if let template = template {
            self.selectedTemplate = template
        } else if let savedTemplateId = UserDefaults.standard.string(forKey: "selectedTemplateId"),
                  let savedTemplate = Template.find(byId: savedTemplateId) {
            self.selectedTemplate = savedTemplate
        } else {
            self.selectedTemplate = Template.allTemplates.first!
        }
    }
    
    // MARK: - Computed
    
    /// هل المستخدم Premium؟
    var isPremium: Bool {
        purchaseManager.isPremium
    }
    
    /// هل يمكن التصدير؟
    var canExport: Bool {
        purchaseManager.canExport
    }
    
    /// التصديرات المتبقية
    var remainingExports: Int {
        purchaseManager.remainingExports
    }
    
    /// هل يجب إضافة علامة مائية؟
    var shouldAddWatermark: Bool {
        purchaseManager.shouldAddWatermark
    }
    
    /// نص العلامة المائية
    var watermarkText: String {
        purchaseManager.watermarkText
    }
    
    /// هل السيرة فارغة؟
    var isEmptyCV: Bool {
        cv.fullName.isEmpty && cv.experiences.isEmpty && cv.educations.isEmpty
    }
    
    // MARK: - Methods
    
    /// تصدير PDF
    @MainActor
    func exportPDF() async {
        // التحقق من حد التصدير
        guard canExport else {
            showExportLimitAlert = true
            return
        }
        
        isExporting = true
        
        do {
            // إنشاء PDF
            let pdfData = try pdfService.exportPDF(cv: cv, addWatermark: shouldAddWatermark)
            generatedPDFData = pdfData
            
            // حفظ الملف
            let fileName = cv.cvName.isEmpty ? "CV_\(Date().timeIntervalSince1970)" : cv.cvName.replacingOccurrences(of: " ", with: "_")
            savedPDFURL = try pdfService.savePDFToFiles(data: pdfData, fileName: fileName)
            
            // تسجيل التصدير
            purchaseManager.recordExport()
            
            isExporting = false
            showShareSheet = true
            
        } catch {
            isExporting = false
            errorMessage = error.localizedDescription
            showExportError = true
        }
    }
    
    // ═══════════════════════════════════════════
    // MARK: - ✅ Fixed: Select Template
    // ═══════════════════════════════════════════
    
    /// تغيير القالب
    func selectTemplate(_ template: Template) {
        // التحقق من توفر القالب باستخدام isAvailable
        if template.isAvailable {
            // القالب متاح - استخدمه
            selectedTemplate = template
            
            // حفظ اختيار المستخدم
            UserDefaults.standard.set(template.id, forKey: "selectedTemplateId")
            
            showTemplateSelector = false
        } else {
            // القالب مقفل - يحتاج شراء أو اشتراك
            showTemplateSelector = false
            showTemplateLocked = true
        }
    }
    
    /// تكبير
    func zoomIn() {
        withAnimation(.easeInOut(duration: 0.2)) {
            scale = min(scale + 0.1, 1.5)
        }
    }
    
    /// تصغير
    func zoomOut() {
        withAnimation(.easeInOut(duration: 0.2)) {
            scale = max(scale - 0.1, 0.3)
        }
    }
    
    /// ملائمة الشاشة
    func fitToScreen() {
        withAnimation(.easeInOut(duration: 0.2)) {
            scale = 0.55
        }
    }
    
    /// مشاركة PDF
    func getShareItems() -> [Any] {
        var items: [Any] = []
        
        if let pdfData = generatedPDFData {
            items.append(pdfData)
        }
        
        if let url = savedPDFURL {
            items.append(url)
        }
        
        return items
    }
}

// MARK: - Export Format
enum ExportFormat: String, CaseIterable, Identifiable {
    case pdf = "PDF"
    case png = "PNG"
    case jpg = "JPG"
    
    var id: String { rawValue }
    
    var fileExtension: String {
        rawValue.lowercased()
    }
    
    var mimeType: String {
        switch self {
        case .pdf: return "application/pdf"
        case .png: return "image/png"
        case .jpg: return "image/jpeg"
        }
    }
}
