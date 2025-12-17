//
//  PDFManager.swift
//  Seerati
//
//  Path: Seerati/Managers/PDFManager.swift
//

import SwiftUI
import PDFKit

// MARK: - PDF Manager
/// مدير تصدير السيرة الذاتية كـ PDF
@MainActor
final class PDFManager {
    
    // MARK: - Singleton
    static let shared = PDFManager()
    
    // MARK: - Constants
    /// حجم صفحة A4 بالنقاط (72 نقطة = 1 إنش)
    static let a4Size = CGSize(width: 595, height: 842)
    
    /// حجم صفحة Letter
    static let letterSize = CGSize(width: 612, height: 792)
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Export Methods
    
    /// تصدير View كـ PDF
    /// - Parameters:
    ///   - content: محتوى SwiftUI View
    ///   - fileName: اسم الملف
    ///   - pageSize: حجم الصفحة (افتراضي A4)
    /// - Returns: URL للملف المُصدّر
    func exportPDF<Content: View>(
        content: Content,
        fileName: String,
        pageSize: CGSize = a4Size
    ) -> URL? {
        let quality = UserDefaultsManager.shared.exportQuality
        let renderer = ImageRenderer(content: content)
        renderer.scale = quality.scale
        
        // إنشاء مسار الملف
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension("pdf")
        
        // إنشاء PDF
        renderer.render { size, context in
            var box = CGRect(origin: .zero, size: pageSize)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            pdf.beginPDFPage(nil)
            
            // حساب scale للمحتوى ليناسب الصفحة
            let scaleX = pageSize.width / size.width
            let scaleY = pageSize.height / size.height
            let scale = min(scaleX, scaleY)
            
            // توسيط المحتوى
            let offsetX = (pageSize.width - size.width * scale) / 2
            let offsetY = (pageSize.height - size.height * scale) / 2
            
            pdf.translateBy(x: offsetX, y: offsetY)
            pdf.scaleBy(x: scale, y: scale)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        // تحديث الإحصائيات
        UserDefaultsManager.shared.incrementExportCount()
        
        return url
    }
    
    /// تصدير سيرة ذاتية كـ PDF باستخدام قالب معين
    func exportCV(
        cv: CVData,
        templateId: String,
        fileName: String? = nil
    ) -> URL? {
        let template = createTemplateView(for: cv, templateId: templateId)
        let name = fileName ?? "\(cv.fullName.isEmpty ? "CV" : cv.fullName)_\(Date().formatted(.dateTime.year().month().day()))"
        return exportPDF(content: template, fileName: name)
    }
    
    /// إنشاء View للقالب المحدد
    @ViewBuilder
    private func createTemplateView(for cv: CVData, templateId: String) -> some View {
        // هنا يتم اختيار القالب المناسب
        // سيتم تنفيذ كل قالب لاحقاً
        SwissMinimalTemplateView(cv: cv)
    }
    
    // MARK: - Share
    
    /// مشاركة ملف PDF
    func sharePDF(url: URL) {
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        // الحصول على الـ ViewController الحالي
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            
            // للـ iPad
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = rootVC.view
                popover.sourceRect = CGRect(
                    x: rootVC.view.bounds.midX,
                    y: rootVC.view.bounds.midY,
                    width: 0,
                    height: 0
                )
            }
            
            rootVC.present(activityVC, animated: true)
        }
    }
    
    /// تصدير ومشاركة مباشرة
    func exportAndShare(cv: CVData, templateId: String) {
        if let url = exportCV(cv: cv, templateId: templateId) {
            sharePDF(url: url)
        }
    }
    
    // MARK: - Save to Files
    
    /// حفظ PDF في تطبيق الملفات
    func savePDFToFiles(url: URL, completion: @escaping (Bool) -> Void) {
        let documentPicker = UIDocumentPickerViewController(
            forExporting: [url],
            asCopy: true
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(documentPicker, animated: true)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    // MARK: - Preview
    
    /// إنشاء صورة معاينة للسيرة الذاتية
    func createPreviewImage(cv: CVData, templateId: String) -> UIImage? {
        let template = createTemplateView(for: cv, templateId: templateId)
        let renderer = ImageRenderer(content: template)
        renderer.scale = 2.0
        return renderer.uiImage
    }
}

// MARK: - Placeholder Template View
/// قالب مؤقت (سيتم استبداله بالقوالب الفعلية)
struct SwissMinimalTemplateView: View {
    let cv: CVData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(cv.fullName)
                    .font(.system(size: 28, weight: .bold))
                Text(cv.jobTitle)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            // Contact
            HStack(spacing: 16) {
                if !cv.email.isEmpty {
                    Text(cv.email)
                        .font(.system(size: 11))
                }
                if !cv.phone.isEmpty {
                    Text(cv.phone)
                        .font(.system(size: 11))
                }
                if !cv.location.isEmpty {
                    Text(cv.location)
                        .font(.system(size: 11))
                }
            }
            .foregroundStyle(.secondary)
            
            // Summary
            if !cv.summary.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("SUMMARY")
                        .font(.system(size: 12, weight: .semibold))
                    Text(cv.summary)
                        .font(.system(size: 11))
                }
            }
            
            // Experience
            if !cv.experiences.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("EXPERIENCE")
                        .font(.system(size: 12, weight: .semibold))
                    
                    ForEach(cv.experiences) { exp in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exp.jobTitle)
                                .font(.system(size: 12, weight: .medium))
                            Text("\(exp.company) • \(exp.dateRangeText)")
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                            
                            if !exp.jobDescription.isEmpty  {
                                Text(exp.jobDescription)
                                    .font(.system(size: 10))
                            }
                        }
                    }
                }
            }
            
            // Education
            if !cv.educations.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("EDUCATION")
                        .font(.system(size: 12, weight: .semibold))
                    
                    ForEach(cv.educations) { edu in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(edu.fullDegreeText)
                                .font(.system(size: 12, weight: .medium))
                            Text("\(edu.institution) • \(edu.yearText)")
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            
            // Skills
            if !cv.skills.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("SKILLS")
                        .font(.system(size: 12, weight: .semibold))
                    
                    FlowLayout(spacing: 6) {
                        ForEach(cv.skills) { skill in
                            Text(skill.name)
                                .font(.system(size: 10))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(40)
        .frame(width: PDFManager.a4Size.width, height: PDFManager.a4Size.height)
        .background(.white)
    }
}

// MARK: - Flow Layout
/// تخطيط متدفق للمهارات
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + rowHeight)
        }
    }
}
