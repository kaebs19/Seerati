//
//  Experience.swift
//  Seerati
//
//  Path: Seerati/Models/Experience.swift
//

import Foundation
import SwiftData

// MARK: - Experience Model
/// نموذج الخبرة العملية
@Model
final class Experience {
    
    // MARK: - Properties
    var id: UUID
    
    /// المسمى الوظيفي
    var jobTitle: String
    
    /// اسم الشركة
    var company: String
    
    /// الموقع
    var location: String
    
    /// تاريخ البداية
    var startDate: Date
    
    /// تاريخ النهاية (nil = حتى الآن)
    var endDate: Date?
    
    /// هل لا يزال يعمل هنا؟
    var isCurrentJob: Bool
    
    /// وصف المهام والإنجازات
    var jobDescription: String
    
    /// ترتيب العرض
    var sortOrder: Int
    
    // MARK: - Relationship
    var cv: CVData?
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        jobTitle: String = "",
        company: String = "",
        location: String = "",
        startDate: Date = Date(),
        endDate: Date? = nil,
        isCurrentJob: Bool = false,
        jobDescription: String = "",
        sortOrder: Int = 0
    ) {
        self.id = id
        self.jobTitle = jobTitle
        self.company = company
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.isCurrentJob = isCurrentJob
        self.jobDescription = jobDescription
        self.sortOrder = sortOrder
    }
    
    // MARK: - Computed Properties
    /// نص الفترة الزمنية
    var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        let start = formatter.string(from: startDate)
        
        if isCurrentJob {
            return "\(start) - Present"
        } else if let end = endDate {
            return "\(start) - \(formatter.string(from: end))"
        }
        return start
    }
    
    /// نص الفترة الزمنية بالعربية
    var dateRangeTextArabic: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.dateFormat = "MMM yyyy"
        
        let start = formatter.string(from: startDate)
        
        if isCurrentJob {
            return "\(start) - حتى الآن"
        } else if let end = endDate {
            return "\(start) - \(formatter.string(from: end))"
        }
        return start
    }
    
    /// مدة العمل بالأشهر
    var durationInMonths: Int {
        let end = isCurrentJob ? Date() : (endDate ?? Date())
        let components = Calendar.current.dateComponents([.month], from: startDate, to: end)
        return components.month ?? 0
    }
    
    /// نص مدة العمل
    var durationText: String {
        let months = durationInMonths
        let years = months / 12
        let remainingMonths = months % 12
        
        if years > 0 && remainingMonths > 0 {
            return "\(years) yr \(remainingMonths) mo"
        } else if years > 0 {
            return "\(years) yr"
        } else {
            return "\(months) mo"
        }
    }
}

// MARK: - Experience Extensions
extension Experience {
    static var preview: Experience {
        Experience(
            jobTitle: "Senior Product Designer",
            company: "Tech Corp",
            location: "San Francisco, CA",
            startDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(),
            isCurrentJob: true,
            jobDescription: "• Led design for mobile app with 1M+ users\n• Collaborated with engineering team\n• Improved user retention by 25%"
        )
    }
}
