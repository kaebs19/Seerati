//
//  PDFManager.swift
//  Seerati
//
//  Path: Seerati/Managers/PDFManager.swift
//
//  ─────────────────────────────────────────────────
//  AR: مدير تصدير السيرة الذاتية كـ PDF - محدث
//  EN: CV PDF Export Manager - Updated
//  ─────────────────────────────────────────────────

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
    func exportPDF<Content: View>(
        content: Content,
        fileName: String,
        pageSize: CGSize = a4Size
    ) -> URL? {
        let quality = UserDefaultsManager.shared.exportQuality
        let renderer = ImageRenderer(content: content)
        renderer.scale = quality.scale
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension("pdf")
        
        renderer.render { size, context in
            var box = CGRect(origin: .zero, size: pageSize)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            pdf.beginPDFPage(nil)
            
            let scaleX = pageSize.width / size.width
            let scaleY = pageSize.height / size.height
            let scale = min(scaleX, scaleY)
            
            let offsetX = (pageSize.width - size.width * scale) / 2
            let offsetY = (pageSize.height - size.height * scale) / 2
            
            pdf.translateBy(x: offsetX, y: offsetY)
            pdf.scaleBy(x: scale, y: scale)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
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
        switch templateId {
        case "swiss_minimal":
            SwissMinimalTemplateView(cv: cv)
        default:
            SwissMinimalTemplateView(cv: cv)
        }
    }
    
    // MARK: - Share
    
    /// مشاركة ملف PDF
    func sharePDF(url: URL) {
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            
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

// MARK: - Swiss Minimal Template View (Updated)
/// قالب Swiss Minimal المحدث مع الصورة والمعلومات الشخصية
struct SwissMinimalTemplateView: View {
    let cv: CVData
    
    // MARK: - Environment
    private var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Colors
    private let primaryColor = Color(hex: "1A1A1A")
    private let secondaryColor = Color(hex: "666666")
    private let accentColor = Color(hex: "2563EB")
    private let dividerColor = Color(hex: "E5E5E5")
    private let chipBgColor = Color(hex: "F5F5F5")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ═══════════════════════════════════════════
            // MARK: - Header with Photo
            // ═══════════════════════════════════════════
            headerSection
                .padding(.bottom, 12)
            
            // Divider
            Rectangle()
                .fill(dividerColor)
                .frame(height: 1)
                .padding(.bottom, 16)
            
            // ═══════════════════════════════════════════
            // MARK: - Two Column Layout
            // ═══════════════════════════════════════════
            HStack(alignment: .top, spacing: 20) {
                // Main Column (65%)
                mainColumn
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Side Column (35%)
                sideColumn
                    .frame(width: 150)
            }
            
            Spacer(minLength: 0)
        }
        .padding(28)
        .frame(width: PDFManager.a4Size.width, height: PDFManager.a4Size.height)
        .background(.white)
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(alignment: .top, spacing: 15) {
            // ✅ Profile Photo
            if let photoData = cv.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(accentColor.opacity(0.3), lineWidth: 2)
                    )
            } else {
                // Default Avatar
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.1))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(accentColor.opacity(0.5))
                }
            }
            
            // Name & Title
            VStack(alignment: .leading, spacing: 4) {
                Text(cv.fullName.isEmpty ? "Your Name" : cv.fullName)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(primaryColor)
                    .lineLimit(1)
                
                if !cv.jobTitle.isEmpty {
                    Text(cv.jobTitle.uppercased())
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(accentColor)
                        .tracking(1.5)
                }
                
                // Contact Row
                contactInfoRow
            }
            
            Spacer()
        }
    }
    
    // MARK: - Contact Info Row
    private var contactInfoRow: some View {
        HStack(spacing: 12) {
            if !cv.email.isEmpty {
                miniContact(icon: "envelope.fill", text: cv.email)
            }
            if !cv.phone.isEmpty {
                miniContact(icon: "phone.fill", text: cv.phone)
            }
            if !cv.location.isEmpty {
                miniContact(icon: "location.fill", text: cv.location)
            }
        }
        .padding(.top, 4)
    }
    
    private func miniContact(icon: String, text: String) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 8))
                .foregroundStyle(accentColor)
            Text(text)
                .font(.system(size: 8))
                .foregroundStyle(secondaryColor)
                .lineLimit(1)
        }
    }
    
    // MARK: - Main Column
    private var mainColumn: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Summary
            if !cv.summary.isEmpty {
                sectionView(title: isArabic ? "نبذة عني" : "PROFILE") {
                    Text(cv.summary)
                        .font(.system(size: 9))
                        .foregroundStyle(secondaryColor)
                        .lineSpacing(2)
                }
            }
            
            // Experience
            if !cv.experiences.isEmpty {
                sectionView(title: isArabic ? "الخبرات العملية" : "EXPERIENCE") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(cv.experiences.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { exp in
                            experienceItem(exp)
                        }
                    }
                }
            }
            
            // Education
            if !cv.educations.isEmpty {
                sectionView(title: isArabic ? "التعليم" : "EDUCATION") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(cv.educations.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { edu in
                            educationItem(edu)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Side Column
    private var sideColumn: some View {
        VStack(alignment: .leading, spacing: 16) {
            // ═══════════════════════════════════════════
            // ✅ Personal Info Section
            // ═══════════════════════════════════════════
            if hasVisiblePersonalInfo {
                sectionView(title: isArabic ? "معلومات شخصية" : "PERSONAL") {
                    VStack(alignment: .leading, spacing: 5) {
                        // تاريخ الميلاد مع العمر
                        if cv.showDateOfBirth, cv.dateOfBirth != nil {
                            let ageText = cv.age != nil ? " (\(cv.age!) \(isArabic ? "سنة" : "yrs"))" : ""
                            infoRow(icon: "calendar", text: cv.formattedDateOfBirth + ageText)
                        }
                        
                        // الجنسية
                        if cv.showNationality, !cv.nationality.isEmpty {
                            infoRow(icon: "globe", text: cv.nationality)
                        }
                        
                        // الجنس
                        if cv.showGender, cv.gender != .preferNotToSay {
                            infoRow(icon: "person.fill", text: isArabic ? cv.gender.localizedName : cv.gender.englishName)
                        }
                        
                        // الحالة الاجتماعية
                        if cv.showMaritalStatus, cv.maritalStatus != .preferNotToSay {
                            infoRow(icon: "heart.fill", text: isArabic ? cv.maritalStatus.localizedName : cv.maritalStatus.englishName)
                        }
                        
                        // رخصة القيادة
                        if cv.showDrivingLicense, cv.drivingLicense != .none {
                            infoRow(icon: "car.fill", text: isArabic ? cv.drivingLicense.localizedName : cv.drivingLicense.englishName)
                        }
                        
                        // حالة الإقامة
                        if cv.showVisaStatus {
                            infoRow(icon: "doc.text.fill", text: isArabic ? cv.visaStatus.localizedName : cv.visaStatus.englishName)
                        }
                    }
                }
            }
            
            // Links
            if !cv.website.isEmpty || !cv.linkedin.isEmpty {
                sectionView(title: isArabic ? "روابط" : "LINKS") {
                    VStack(alignment: .leading, spacing: 5) {
                        if !cv.website.isEmpty {
                            infoRow(icon: "globe", text: cv.website)
                        }
                        if !cv.linkedin.isEmpty {
                            infoRow(icon: "link", text: cv.linkedin)
                        }
                    }
                }
            }
            
            // Skills
            if !cv.skills.isEmpty {
                sectionView(title: isArabic ? "المهارات" : "SKILLS") {
                    FlowLayout(spacing: 4) {
                        ForEach(cv.skills.sorted { $0.sortOrder < $1.sortOrder }, id: \.id) { skill in
                            skillChip(skill.name)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func sectionView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(primaryColor)
                .tracking(1.2)
            content()
        }
    }
    
    private func experienceItem(_ exp: Experience) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .top) {
                Text(exp.jobTitle)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(primaryColor)
                Spacer()
                Text(isArabic ? exp.dateRangeTextArabic : exp.dateRangeText)
                    .font(.system(size: 8))
                    .foregroundStyle(secondaryColor)
            }
            
            Text(exp.company)
                .font(.system(size: 9))
                .foregroundStyle(accentColor)
            
            if !exp.location.isEmpty {
                Text(exp.location)
                    .font(.system(size: 8))
                    .foregroundStyle(secondaryColor)
            }
            
            if !exp.jobDescription.isEmpty {
                Text(exp.jobDescription)
                    .font(.system(size: 8))
                    .foregroundStyle(secondaryColor)
                    .lineSpacing(1.5)
                    .padding(.top, 2)
                    .lineLimit(4)
            }
        }
    }
    
    private func educationItem(_ edu: Education) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .top) {
                Text(edu.degree)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(primaryColor)
                    .lineLimit(1)
                Spacer()
                Text(edu.dateRangeText)
                    .font(.system(size: 8))
                    .foregroundStyle(secondaryColor)
            }
            
            Text(edu.institution)
                .font(.system(size: 9))
                .foregroundStyle(accentColor)
            
            if !edu.fieldOfStudy.isEmpty {
                Text(edu.fieldOfStudy)
                    .font(.system(size: 8))
                    .foregroundStyle(secondaryColor)
            }
            
            if !edu.location.isEmpty {
                HStack(spacing: 3) {
                    Image(systemName: "location")
                        .font(.system(size: 7))
                    Text(edu.location)
                        .font(.system(size: 8))
                }
                .foregroundStyle(secondaryColor)
            }
            
            if !edu.gpa.isEmpty {
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 7))
                    Text("GPA: \(edu.gpa)")
                        .font(.system(size: 8, weight: .medium))
                }
                .foregroundStyle(Color.orange)
                .padding(.top, 1)
            }
        }
    }
    
    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 8))
                .foregroundStyle(accentColor)
                .frame(width: 12)
            Text(text)
                .font(.system(size: 8))
                .foregroundStyle(secondaryColor)
                .lineLimit(2)
        }
    }
    
    private func skillChip(_ name: String) -> some View {
        Text(name)
            .font(.system(size: 7, weight: .medium))
            .foregroundStyle(primaryColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(chipBgColor)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }
    
    // MARK: - Computed
    private var hasVisiblePersonalInfo: Bool {
        (cv.showDateOfBirth && cv.dateOfBirth != nil) ||
        (cv.showNationality && !cv.nationality.isEmpty) ||
        (cv.showGender && cv.gender != .preferNotToSay) ||
        (cv.showMaritalStatus && cv.maritalStatus != .preferNotToSay) ||
        (cv.showDrivingLicense && cv.drivingLicense != .none) ||
        cv.showVisaStatus
    }
}
