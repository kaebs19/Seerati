//
//  Education.swift
//  Seerati
//
//  Path: Seerati/Models/Education.swift
//

import Foundation
import SwiftData

// MARK: - Education Model
/// نموذج التعليم
@Model
final class Education {
    
    // MARK: - Properties
    var id: UUID
    
    /// الدرجة العلمية
    var degree: String
    
    /// التخصص
    var fieldOfStudy: String
    
    /// اسم المؤسسة التعليمية
    var institution: String
    
    /// الموقع
    var location: String
    
    /// تاريخ البداية
    var startDate: Date
    
    /// تاريخ التخرج
    var endDate: Date?
    
    /// هل لا يزال يدرس؟
    var isCurrentlyStudying: Bool
    
    /// المعدل (اختياري)
    var gpa: String
    
    /// ملاحظات إضافية
    var notes: String
    
    /// ترتيب العرض
    var sortOrder: Int
    
    // MARK: - Relationship
    var cv: CVData?
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        degree: String = "",
        fieldOfStudy: String = "",
        institution: String = "",
        location: String = "",
        startDate: Date = Date(),
        endDate: Date? = nil,
        isCurrentlyStudying: Bool = false,
        gpa: String = "",
        notes: String = "",
        sortOrder: Int = 0
    ) {
        self.id = id
        self.degree = degree
        self.fieldOfStudy = fieldOfStudy
        self.institution = institution
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.isCurrentlyStudying = isCurrentlyStudying
        self.gpa = gpa
        self.notes = notes
        self.sortOrder = sortOrder
    }
    
    // MARK: - Computed Properties
    /// النص الكامل للدرجة
    var fullDegreeText: String {
        if fieldOfStudy.isEmpty {
            return degree
        }
        return "\(degree) in \(fieldOfStudy)"
    }
    
    /// نص السنة
    var yearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        if isCurrentlyStudying {
            return "Expected \(formatter.string(from: endDate ?? Date()))"
        } else if let end = endDate {
            return formatter.string(from: end)
        }
        return formatter.string(from: startDate)
    }
    
    /// نص الفترة الزمنية
    var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        let start = formatter.string(from: startDate)
        
        if isCurrentlyStudying {
            return "\(start) - Present"
        } else if let end = endDate {
            return "\(start) - \(formatter.string(from: end))"
        }
        return start
    }
}

// MARK: - Degree Type
enum DegreeType: String, CaseIterable {
    case highSchool = "High School Diploma"
    case associate = "Associate Degree"
    case bachelor = "Bachelor's Degree"
    case master = "Master's Degree"
    case doctorate = "Doctorate (Ph.D.)"
    case diploma = "Diploma"
    case certificate = "Certificate"
    case other = "Other"
    
    var arabicName: String {
        switch self {
        case .highSchool: return "شهادة الثانوية"
        case .associate: return "دبلوم مشارك"
        case .bachelor: return "بكالوريوس"
        case .master: return "ماجستير"
        case .doctorate: return "دكتوراه"
        case .diploma: return "دبلوم"
        case .certificate: return "شهادة"
        case .other: return "أخرى"
        }
    }
}

// MARK: - Education Extensions
extension Education {
    static var preview: Education {
        Education(
            degree: "Bachelor's Degree",
            fieldOfStudy: "Computer Science",
            institution: "Stanford University",
            location: "Stanford, CA",
            startDate: Calendar.current.date(byAdding: .year, value: -6, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()),
            gpa: "3.8"
        )
    }
}
