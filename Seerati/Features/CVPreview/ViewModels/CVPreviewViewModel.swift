//
//  CVPreviewViewModel.swift
//  Seerati
//
//  Path: Seerati/Features/CVPreview/ViewModels/CVPreviewViewModel.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة حالة ومنطق معاينة السيرة
//  EN: CV Preview state and logic management
//  ─────────────────────────────────────────────

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
    var scale: CGFloat = 1.0
    
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
    
    /// PDF المُنشأ
    var generatedPDFData: Data?
    
    /// إظهار Share Sheet
    var showShareSheet: Bool = false
    
    // MARK: - Managers
    let purchaseManager = PurchaseManager.shared
    // MARK: - Init
    init(cv: CVData, template: Template? = nil) {
        self.cv = cv
        self.selectedTemplate = template ?? Template.allTemplates.first!
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
            let pdfData = try await generatePDF()
            generatedPDFData = pdfData
            
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
    
    /// إنشاء PDF
    private func generatePDF() async throws -> Data {
        // TODO: تنفيذ إنشاء PDF الفعلي
        // حالياً نُرجع بيانات وهمية
        
        try await Task.sleep(nanoseconds: 1_500_000_000) // محاكاة
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))
        
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            
            // هذا placeholder - سيتم استبداله بالقالب الفعلي
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold)
            ]
            cv.fullName.draw(at: CGPoint(x: 50, y: 50), withAttributes: attrs)
        }
        
        return data
    }
    
    /// تغيير القالب
    func selectTemplate(_ template: Template) {
        // التحقق من توفر القالب
        if template.isAvailable {
            selectedTemplate = template
            showTemplateSelector = false
        } else {
            // يحتاج شراء
            showPremiumPage = true
        }
    }
    
    /// تكبير
    func zoomIn() {
        withAnimation(.easeInOut(duration: 0.2)) {
            scale = min(scale + 0.25, 2.0)
        }
    }
    
    /// تصغير
    func zoomOut() {
        withAnimation(.easeInOut(duration: 0.2)) {
            scale = max(scale - 0.25, 0.5)
        }
    }
    
    /// ملائمة الشاشة
    func fitToScreen() {
        withAnimation(.easeInOut(duration: 0.2)) {
            scale = 1.0
        }
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
