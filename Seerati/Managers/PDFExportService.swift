//
//  PDFExportService.swift
//  Seerati
//
//  Path: Seerati/Managers/PDFExportService.swift
//
//  ─────────────────────────────────────────────────
//  AR: خدمة تصدير السيرة الذاتية كـ PDF - محدث
//  EN: CV PDF Export Service - Updated with Personal Info
//  ─────────────────────────────────────────────────

import SwiftUI
import PDFKit
import UIKit

// MARK: - PDF Export Service
final class PDFExportService {
    
    // MARK: - Singleton
    static let shared = PDFExportService()
    private init() {}
    
    // MARK: - Constants
    private let pageWidth: CGFloat = 595.0   // A4 width in points
    private let pageHeight: CGFloat = 842.0  // A4 height in points
    private let margin: CGFloat = 40.0
    
    // MARK: - Colors
    private let primaryColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    private let secondaryColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    private let accentColor = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0)
    private let dividerColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    
    // MARK: - Language
    private var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    // MARK: - Fonts
    private func titleFont() -> UIFont {
        UIFont.systemFont(ofSize: 28, weight: .bold)
    }
    
    private func subtitleFont() -> UIFont {
        UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    private func sectionTitleFont() -> UIFont {
        UIFont.systemFont(ofSize: 11, weight: .bold)
    }
    
    private func bodyFont() -> UIFont {
        UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
    private func bodyBoldFont() -> UIFont {
        UIFont.systemFont(ofSize: 10, weight: .semibold)
    }
    
    private func captionFont() -> UIFont {
        UIFont.systemFont(ofSize: 9, weight: .regular)
    }
    
    // MARK: - Export PDF
    func exportPDF(cv: CVData, addWatermark: Bool = false) throws -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            var yPosition: CGFloat = margin
            let contentWidth = pageWidth - (margin * 2)
            let mainColumnWidth = contentWidth * 0.62
            let sideColumnWidth = contentWidth * 0.33
            let sideColumnX = margin + mainColumnWidth + (contentWidth * 0.05)
            
            // ═══════════════════════════════════════════
            // MARK: Header Section with Photo
            // ═══════════════════════════════════════════

            let photoSize: CGFloat = 70
            var textStartX = margin

            // رسم الصورة الشخصية
            if let photoData = cv.photoData, let image = UIImage(data: photoData) {
                let photoRect = CGRect(x: margin, y: yPosition, width: photoSize, height: photoSize)
                
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                
                let circlePath = UIBezierPath(ovalIn: photoRect)
                circlePath.addClip()
                image.draw(in: photoRect)
                
                context?.restoreGState()
                
                // إطار حول الصورة
                UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 0.3).setStroke()
                circlePath.lineWidth = 2
                circlePath.stroke()
                
                textStartX = margin + photoSize + 15
            }

            // Name
            let nameText = cv.fullName.isEmpty ? "Your Name" : cv.fullName
            let nameAttrs: [NSAttributedString.Key: Any] = [
                .font: titleFont(),
                .foregroundColor: primaryColor
            ]
            let nameRect = CGRect(x: textStartX, y: yPosition, width: contentWidth - (textStartX - margin), height: 35)
            nameText.draw(in: nameRect, withAttributes: nameAttrs)

            // Job Title
            if !cv.jobTitle.isEmpty {
                let jobAttrs: [NSAttributedString.Key: Any] = [
                    .font: subtitleFont(),
                    .foregroundColor: accentColor
                ]
                let jobRect = CGRect(x: textStartX, y: yPosition + 35, width: contentWidth - (textStartX - margin), height: 20)
                cv.jobTitle.uppercased().draw(in: jobRect, withAttributes: jobAttrs)
            }
            
            // Contact Info Row (تحت الاسم)
            var contactY = yPosition + 55
            let contactItems = buildContactItems(cv: cv)
            if !contactItems.isEmpty {
                let contactAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 9),
                    .foregroundColor: secondaryColor
                ]
                let contactText = contactItems.joined(separator: "  •  ")
                let contactRect = CGRect(x: textStartX, y: contactY, width: contentWidth - (textStartX - margin), height: 15)
                contactText.draw(in: contactRect, withAttributes: contactAttrs)
            }

            // تحديد yPosition بناءً على وجود الصورة
            if cv.photoData != nil {
                yPosition += photoSize + 15
            } else {
                yPosition += 75
            }

            // Divider
            yPosition += 10
            drawDivider(at: yPosition, width: contentWidth, x: margin)
            yPosition += 20
            
            // ═══════════════════════════════════════════
            // MARK: Two Column Layout
            // ═══════════════════════════════════════════
            
            var mainColumnY = yPosition
            var sideColumnY = yPosition
            
            // ─────────────────────────────────────────
            // MAIN COLUMN (Left)
            // ─────────────────────────────────────────
            
            // Summary
            if !cv.summary.isEmpty {
                mainColumnY = drawSection(
                    title: isArabic ? "نبذة عني" : "PROFILE",
                    at: mainColumnY,
                    x: margin,
                    width: mainColumnWidth
                )
                mainColumnY = drawText(
                    cv.summary,
                    at: mainColumnY,
                    x: margin,
                    width: mainColumnWidth,
                    font: bodyFont(),
                    color: secondaryColor
                )
                mainColumnY += 15
            }
            
            // Experience
            if !cv.experiences.isEmpty {
                mainColumnY = drawSection(
                    title: isArabic ? "الخبرات العملية" : "EXPERIENCE",
                    at: mainColumnY,
                    x: margin,
                    width: mainColumnWidth
                )
                
                for experience in cv.experiences.sorted(by: { $0.sortOrder < $1.sortOrder }) {
                    mainColumnY = drawExperience(experience, at: mainColumnY, x: margin, width: mainColumnWidth)
                }
                mainColumnY += 10
            }
            
            // Education
            if !cv.educations.isEmpty {
                mainColumnY = drawSection(
                    title: isArabic ? "التعليم" : "EDUCATION",
                    at: mainColumnY,
                    x: margin,
                    width: mainColumnWidth
                )
                
                for education in cv.educations.sorted(by: { $0.sortOrder < $1.sortOrder }) {
                    mainColumnY = drawEducation(education, at: mainColumnY, x: margin, width: mainColumnWidth)
                }
            }
            
            // ─────────────────────────────────────────
            // SIDE COLUMN (Right)
            // ─────────────────────────────────────────
            
            // ═══════════════════════════════════════════
            // MARK: ✅ Personal Info Section
            // ═══════════════════════════════════════════
            if hasVisiblePersonalInfo(cv: cv) {
                sideColumnY = drawSection(
                    title: isArabic ? "معلومات شخصية" : "PERSONAL",
                    at: sideColumnY,
                    x: sideColumnX,
                    width: sideColumnWidth
                )
                
                // تاريخ الميلاد مع العمر
                if cv.showDateOfBirth, cv.dateOfBirth != nil {
                    var dobText = cv.formattedDateOfBirth
                    if let age = cv.age {
                        dobText += " (\(age) \(isArabic ? "سنة" : "yrs"))"
                    }
                    sideColumnY = drawInfoRow(icon: "📅", text: dobText, at: sideColumnY, x: sideColumnX, width: sideColumnWidth)
                }
                
                // الجنسية
                if cv.showNationality, !cv.nationality.isEmpty {
                    sideColumnY = drawInfoRow(icon: "🌍", text: cv.nationality, at: sideColumnY, x: sideColumnX, width: sideColumnWidth)
                }
                
                // الجنس
                if cv.showGender, cv.gender != .preferNotToSay {
                    let genderText = isArabic ? cv.gender.localizedName : cv.gender.englishName
                    sideColumnY = drawInfoRow(icon: "👤", text: genderText, at: sideColumnY, x: sideColumnX, width: sideColumnWidth)
                }
                
                // الحالة الاجتماعية
                if cv.showMaritalStatus, cv.maritalStatus != .preferNotToSay {
                    let statusText = isArabic ? cv.maritalStatus.localizedName : cv.maritalStatus.englishName
                    sideColumnY = drawInfoRow(icon: "💍", text: statusText, at: sideColumnY, x: sideColumnX, width: sideColumnWidth)
                }
                
                // رخصة القيادة
                if cv.showDrivingLicense, cv.drivingLicense != .none {
                    let licenseText = isArabic ? cv.drivingLicense.localizedName : cv.drivingLicense.englishName
                    sideColumnY = drawInfoRow(icon: "🚗", text: licenseText, at: sideColumnY, x: sideColumnX, width: sideColumnWidth)
                }
                
                // حالة الإقامة
                if cv.showVisaStatus {
                    let visaText = isArabic ? cv.visaStatus.localizedName : cv.visaStatus.englishName
                    sideColumnY = drawInfoRow(icon: "📄", text: visaText, at: sideColumnY, x: sideColumnX, width: sideColumnWidth)
                }
                
                sideColumnY += 15
            }
            
            // Links (Website & LinkedIn)
            if !cv.website.isEmpty || !cv.linkedin.isEmpty {
                sideColumnY = drawSection(
                    title: isArabic ? "روابط" : "LINKS",
                    at: sideColumnY,
                    x: sideColumnX,
                    width: sideColumnWidth
                )
                
                if !cv.website.isEmpty {
                    sideColumnY = drawContactRow(icon: "◉", text: cv.website, at: sideColumnY, x: sideColumnX, width: sideColumnWidth)
                }
                if !cv.linkedin.isEmpty {
                    sideColumnY = drawContactRow(icon: "⬡", text: cv.linkedin, at: sideColumnY, x: sideColumnX, width: sideColumnWidth)
                }
                
                sideColumnY += 15
            }
            
            // Skills
            if !cv.skills.isEmpty {
                sideColumnY = drawSection(
                    title: isArabic ? "المهارات" : "SKILLS",
                    at: sideColumnY,
                    x: sideColumnX,
                    width: sideColumnWidth
                )
                
                sideColumnY = drawSkills(cv.skills, at: sideColumnY, x: sideColumnX, width: sideColumnWidth)
            }
            
            // ═══════════════════════════════════════════
            // MARK: Watermark
            // ═══════════════════════════════════════════
            
            if addWatermark {
                drawWatermark()
            }
        }
        
        return data
    }
    
    // MARK: - Helper: Build Contact Items
    private func buildContactItems(cv: CVData) -> [String] {
        var items: [String] = []
        if !cv.email.isEmpty { items.append("✉ \(cv.email)") }
        if !cv.phone.isEmpty { items.append("☎ \(cv.phone)") }
        if !cv.location.isEmpty { items.append("📍 \(cv.location)") }
        return items
    }
    
    // MARK: - Helper: Has Visible Personal Info
    private func hasVisiblePersonalInfo(cv: CVData) -> Bool {
        (cv.showDateOfBirth && cv.dateOfBirth != nil) ||
        (cv.showNationality && !cv.nationality.isEmpty) ||
        (cv.showGender && cv.gender != .preferNotToSay) ||
        (cv.showMaritalStatus && cv.maritalStatus != .preferNotToSay) ||
        (cv.showDrivingLicense && cv.drivingLicense != .none) ||
        cv.showVisaStatus
    }
    
    // MARK: - Drawing Helpers
    
    private func drawDivider(at y: CGFloat, width: CGFloat, x: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x + width, y: y))
        dividerColor.setStroke()
        path.lineWidth = 1
        path.stroke()
    }
    
    private func drawSection(title: String, at y: CGFloat, x: CGFloat, width: CGFloat) -> CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: sectionTitleFont(),
            .foregroundColor: primaryColor,
            .kern: 1.5
        ]
        let rect = CGRect(x: x, y: y, width: width, height: 15)
        title.draw(in: rect, withAttributes: attrs)
        return y + 18
    }
    
    private func drawText(_ text: String, at y: CGFloat, x: CGFloat, width: CGFloat, font: UIFont, color: UIColor) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let fullAttrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: fullAttrs)
        let boundingRect = attributedString.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        let rect = CGRect(x: x, y: y, width: width, height: boundingRect.height)
        attributedString.draw(in: rect)
        
        return y + boundingRect.height + 5
    }
    
    private func drawExperience(_ exp: Experience, at y: CGFloat, x: CGFloat, width: CGFloat) -> CGFloat {
        var currentY = y
        
        // Job Title
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: bodyBoldFont(),
            .foregroundColor: primaryColor
        ]
        exp.jobTitle.draw(at: CGPoint(x: x, y: currentY), withAttributes: titleAttrs)
        currentY += 14
        
        // Company
        let companyAttrs: [NSAttributedString.Key: Any] = [
            .font: bodyFont(),
            .foregroundColor: accentColor
        ]
        exp.company.draw(at: CGPoint(x: x, y: currentY), withAttributes: companyAttrs)
        
        // Date (right aligned)
        let dateAttrs: [NSAttributedString.Key: Any] = [
            .font: captionFont(),
            .foregroundColor: secondaryColor
        ]
        let dateText = isArabic ? exp.dateRangeTextArabic : exp.dateRangeText
        let dateSize = dateText.size(withAttributes: dateAttrs)
        let dateX = x + width - dateSize.width
        dateText.draw(at: CGPoint(x: dateX, y: currentY), withAttributes: dateAttrs)
        currentY += 14
        
        // Location
        if !exp.location.isEmpty {
            let locAttrs: [NSAttributedString.Key: Any] = [
                .font: captionFont(),
                .foregroundColor: secondaryColor
            ]
            ("📍 " + exp.location).draw(at: CGPoint(x: x, y: currentY), withAttributes: locAttrs)
            currentY += 12
        }
        
        // Description
        if !exp.jobDescription.isEmpty {
            currentY = drawText(
                exp.jobDescription,
                at: currentY,
                x: x,
                width: width,
                font: captionFont(),
                color: secondaryColor
            )
        }
        
        return currentY + 10
    }
    
    private func drawEducation(_ edu: Education, at y: CGFloat, x: CGFloat, width: CGFloat) -> CGFloat {
        var currentY = y
        
        // Degree
        let degreeAttrs: [NSAttributedString.Key: Any] = [
            .font: bodyBoldFont(),
            .foregroundColor: primaryColor
        ]
        edu.degree.draw(at: CGPoint(x: x, y: currentY), withAttributes: degreeAttrs)
        currentY += 14
        
        // Institution
        let instAttrs: [NSAttributedString.Key: Any] = [
            .font: bodyFont(),
            .foregroundColor: accentColor
        ]
        edu.institution.draw(at: CGPoint(x: x, y: currentY), withAttributes: instAttrs)
        
        // Date (right aligned)
        let dateAttrs: [NSAttributedString.Key: Any] = [
            .font: captionFont(),
            .foregroundColor: secondaryColor
        ]
        let dateText = edu.dateRangeText
        let dateSize = dateText.size(withAttributes: dateAttrs)
        let dateX = x + width - dateSize.width
        dateText.draw(at: CGPoint(x: dateX, y: currentY), withAttributes: dateAttrs)
        currentY += 14
        
        // Field of Study
        if !edu.fieldOfStudy.isEmpty {
            let fieldAttrs: [NSAttributedString.Key: Any] = [
                .font: captionFont(),
                .foregroundColor: secondaryColor
            ]
            ("📚 " + edu.fieldOfStudy).draw(at: CGPoint(x: x, y: currentY), withAttributes: fieldAttrs)
            currentY += 12
        }
        
        // Location
        if !edu.location.isEmpty {
            let locAttrs: [NSAttributedString.Key: Any] = [
                .font: captionFont(),
                .foregroundColor: secondaryColor
            ]
            ("📍 " + edu.location).draw(at: CGPoint(x: x, y: currentY), withAttributes: locAttrs)
            currentY += 12
        }
        
        // GPA
        if !edu.gpa.isEmpty {
            let gpaAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 9, weight: .medium),
                .foregroundColor: UIColor.orange
            ]
            ("⭐ GPA: \(edu.gpa)").draw(at: CGPoint(x: x, y: currentY), withAttributes: gpaAttrs)
            currentY += 12
        }
        
        return currentY + 8
    }
    
    private func drawContactRow(icon: String, text: String, at y: CGFloat, x: CGFloat, width: CGFloat) -> CGFloat {
        let iconAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: accentColor
        ]
        icon.draw(at: CGPoint(x: x, y: y), withAttributes: iconAttrs)
        
        let textAttrs: [NSAttributedString.Key: Any] = [
            .font: captionFont(),
            .foregroundColor: secondaryColor
        ]
        
        let maxTextWidth = width - 18
        let truncatedText = truncateText(text, width: maxTextWidth, font: captionFont())
        truncatedText.draw(at: CGPoint(x: x + 16, y: y), withAttributes: textAttrs)
        
        return y + 14
    }
    
    // ✅ جديد: رسم صف معلومات شخصية
    private func drawInfoRow(icon: String, text: String, at y: CGFloat, x: CGFloat, width: CGFloat) -> CGFloat {
        let iconAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: accentColor
        ]
        icon.draw(at: CGPoint(x: x, y: y), withAttributes: iconAttrs)
        
        let textAttrs: [NSAttributedString.Key: Any] = [
            .font: captionFont(),
            .foregroundColor: secondaryColor
        ]
        
        let maxTextWidth = width - 20
        let truncatedText = truncateText(text, width: maxTextWidth, font: captionFont())
        truncatedText.draw(at: CGPoint(x: x + 18, y: y), withAttributes: textAttrs)
        
        return y + 14
    }
    
    private func drawSkills(_ skills: [Skill], at y: CGFloat, x: CGFloat, width: CGFloat) -> CGFloat {
        var currentY = y
        var currentX = x
        let chipPadding: CGFloat = 6
        let chipHeight: CGFloat = 18
        let chipSpacing: CGFloat = 4
        let lineSpacing: CGFloat = 4
        
        let chipFont = UIFont.systemFont(ofSize: 8, weight: .medium)
        let chipAttrs: [NSAttributedString.Key: Any] = [
            .font: chipFont,
            .foregroundColor: primaryColor
        ]
        
        for skill in skills.sorted(by: { $0.sortOrder < $1.sortOrder }) {
            let textSize = skill.name.size(withAttributes: chipAttrs)
            let chipWidth = textSize.width + (chipPadding * 2)
            
            // Check if we need to wrap to next line
            if currentX + chipWidth > x + width {
                currentX = x
                currentY += chipHeight + lineSpacing
            }
            
            // Draw chip background
            let chipRect = CGRect(x: currentX, y: currentY, width: chipWidth, height: chipHeight)
            let chipPath = UIBezierPath(roundedRect: chipRect, cornerRadius: 4)
            UIColor(white: 0.95, alpha: 1.0).setFill()
            chipPath.fill()
            
            // Draw chip text
            let textY = currentY + (chipHeight - textSize.height) / 2
            skill.name.draw(at: CGPoint(x: currentX + chipPadding, y: textY), withAttributes: chipAttrs)
            
            currentX += chipWidth + chipSpacing
        }
        
        return currentY + chipHeight + 10
    }
    
    private func drawWatermark() {
        let watermarkText = "Made with Seerati"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8),
            .foregroundColor: UIColor(white: 0.8, alpha: 1.0)
        ]
        let textSize = watermarkText.size(withAttributes: attrs)
        let x = pageWidth - margin - textSize.width
        let y = pageHeight - 25
        watermarkText.draw(at: CGPoint(x: x, y: y), withAttributes: attrs)
    }
    
    private func truncateText(_ text: String, width: CGFloat, font: UIFont) -> String {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        var truncated = text
        while truncated.size(withAttributes: attrs).width > width && truncated.count > 3 {
            truncated = String(truncated.dropLast(4)) + "..."
        }
        return truncated
    }
    
    // MARK: - Save to Files
    func savePDFToFiles(data: Data, fileName: String) throws -> URL {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(fileName).pdf")
        
        try data.write(to: fileURL)
        return fileURL
    }
}

// MARK: - PDF Export Error
enum PDFExportError: LocalizedError {
    case renderingFailed
    case saveFailed
    case exportLimitReached
    
    var errorDescription: String? {
        switch self {
        case .renderingFailed:
            return "Failed to render PDF"
        case .saveFailed:
            return "Failed to save PDF"
        case .exportLimitReached:
            return "Export limit reached"
        }
    }
}
