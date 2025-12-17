//
//  Project.swift
//  Seerati
//
//  Path: Seerati/Models/Project.swift
//

import Foundation
import SwiftData

// MARK: - Project Model
/// نموذج المشروع
@Model
final class Project {
    
    // MARK: - Properties
    var id: UUID
    
    /// اسم المشروع
    var name: String
    
    /// وصف المشروع
    var projectDescription: String
    
    /// التقنيات المستخدمة
    var technologies: [String]
    
    /// رابط المشروع (اختياري)
    var projectURL: String
    
    /// رابط GitHub (اختياري)
    var githubURL: String
    
    /// تاريخ البداية
    var startDate: Date
    
    /// تاريخ النهاية
    var endDate: Date?
    
    /// ترتيب العرض
    var sortOrder: Int
    
    // MARK: - Relationship
    var cv: CVData?
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        name: String = "",
        projectDescription: String = "",
        technologies: [String] = [],
        projectURL: String = "",
        githubURL: String = "",
        startDate: Date = Date(),
        endDate: Date? = nil,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.projectDescription = projectDescription
        self.technologies = technologies
        self.projectURL = projectURL
        self.githubURL = githubURL
        self.startDate = startDate
        self.endDate = endDate
        self.sortOrder = sortOrder
    }
    
    // MARK: - Computed Properties
    /// نص التقنيات
    var technologiesText: String {
        technologies.joined(separator: ", ")
    }
    
    /// نص التاريخ
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: startDate)
    }
}

// MARK: - Project Extensions
extension Project {
    static var preview: Project {
        Project(
            name: "E-Commerce App",
            projectDescription: "A full-featured e-commerce mobile application with payment integration and real-time inventory management.",
            technologies: ["Swift", "SwiftUI", "Firebase", "Stripe"],
            projectURL: "https://example.com",
            githubURL: "https://github.com/example/app"
        )
    }
}
