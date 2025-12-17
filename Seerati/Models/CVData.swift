//
//  CVData.swift
//  Seerati
//
//  Path: Seerati/Models/CVData.swift
//

import Foundation
import SwiftData

// MARK: - CV Data Model
/// النموذج الرئيسي للسيرة الذاتية
@Model
final class CVData {
    
    // MARK: - Properties
    /// المعرف الفريد
    var id: UUID
    
    /// اسم السيرة الذاتية (للمرجع الشخصي)
    var cvName: String
    
    /// تاريخ الإنشاء
    var createdAt: Date
    
    /// تاريخ آخر تعديل
    var updatedAt: Date
    
    /// القالب المستخدم
    var templateId: String
    
    /// لون القالب المخصص (اختياري)
    var customColor: String?
    
    // MARK: - Personal Info
    /// الاسم الكامل
    var fullName: String
    
    /// المسمى الوظيفي
    var jobTitle: String
    
    /// البريد الإلكتروني
    var email: String
    
    /// رقم الهاتف
    var phone: String
    
    /// الموقع (المدينة، البلد)
    var location: String
    
    /// الموقع الإلكتروني / LinkedIn
    var website: String
    
    /// رابط LinkedIn
    var linkedin: String
    
    /// الصورة الشخصية (Data)
    @Attribute(.externalStorage)
    var photoData: Data?
    
    /// النبذة الشخصية
    var summary: String
    
    // MARK: - Relationships
    /// الخبرات العملية
    @Relationship(deleteRule: .cascade, inverse: \Experience.cv)
    var experiences: [Experience]
    
    /// التعليم
    @Relationship(deleteRule: .cascade, inverse: \Education.cv)
    var educations: [Education]
    
    /// المهارات
    @Relationship(deleteRule: .cascade, inverse: \Skill.cv)
    var skills: [Skill]
    
    /// اللغات
    @Relationship(deleteRule: .cascade, inverse: \LanguageSkill.cv)
    var languages: [LanguageSkill]
    
    /// الشهادات
    @Relationship(deleteRule: .cascade, inverse: \Certificate.cv)
    var certificates: [Certificate]
    
    /// المشاريع
    @Relationship(deleteRule: .cascade, inverse: \Project.cv)
    var projects: [Project]
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        cvName: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        templateId: String = "swiss_minimal",
        customColor: String? = nil,
        fullName: String = "",
        jobTitle: String = "",
        email: String = "",
        phone: String = "",
        location: String = "",
        website: String = "",
        linkedin: String = "",
        photoData: Data? = nil,
        summary: String = "",
        experiences: [Experience] = [],
        educations: [Education] = [],
        skills: [Skill] = [],
        languages: [LanguageSkill] = [],
        certificates: [Certificate] = [],
        projects: [Project] = []
    ) {
        self.id = id
        self.cvName = cvName
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.templateId = templateId
        self.customColor = customColor
        self.fullName = fullName
        self.jobTitle = jobTitle
        self.email = email
        self.phone = phone
        self.location = location
        self.website = website
        self.linkedin = linkedin
        self.photoData = photoData
        self.summary = summary
        self.experiences = experiences
        self.educations = educations
        self.skills = skills
        self.languages = languages
        self.certificates = certificates
        self.projects = projects
    }
    
    // MARK: - Methods
    /// تحديث تاريخ التعديل
    func touch() {
        updatedAt = Date()
    }
    
    /// نسبة اكتمال السيرة الذاتية
    var completionPercentage: Int {
        var score = 0
        var total = 0
        
        // Personal Info (40%)
        total += 8
        if !fullName.isEmpty { score += 1 }
        if !jobTitle.isEmpty { score += 1 }
        if !email.isEmpty { score += 1 }
        if !phone.isEmpty { score += 1 }
        if !location.isEmpty { score += 1 }
        if photoData != nil { score += 1 }
        if !summary.isEmpty { score += 2 }
        
        // Experience (25%)
        total += 2
        if !experiences.isEmpty { score += 2 }
        
        // Education (15%)
        total += 1
        if !educations.isEmpty { score += 1 }
        
        // Skills (15%)
        total += 1
        if !skills.isEmpty { score += 1 }
        
        // Languages (5%)
        total += 1
        if !languages.isEmpty { score += 1 }
        
        return total > 0 ? (score * 100) / total : 0
    }
    
    /// هل السيرة الذاتية مكتملة؟
    var isComplete: Bool {
        completionPercentage >= 80
    }
}

// MARK: - CVData Extensions
extension CVData {
    /// نسخة فارغة للـ Preview
    static var preview: CVData {
        let cv = CVData(
            cvName: "Marketing Resume 2024",
            fullName: "Alex Morgan",
            jobTitle: "Senior Product Designer",
            email: "alex@example.com",
            phone: "+1 (555) 000-0000",
            location: "San Francisco, CA",
            website: "linkedin.com/in/alexmorgan",
            summary: "Creative product designer with 5+ years of experience in creating user-centered digital experiences."
        )
        return cv
    }
    
    /// الوقت المنقضي منذ آخر تعديل
    var lastEditedText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: updatedAt, relativeTo: Date())
    }
}

