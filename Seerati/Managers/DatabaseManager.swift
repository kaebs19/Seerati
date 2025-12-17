//
//  DatabaseManager.swift
//  Seerati
//
//  Path: Seerati/Managers/DatabaseManager.swift
//

import Foundation
import SwiftData

// MARK: - Database Manager
/// مدير قاعدة البيانات باستخدام SwiftData
@MainActor
final class DatabaseManager {
    
    // MARK: - Singleton
    static let shared = DatabaseManager()
    
    // MARK: - Properties
    let container: ModelContainer
    let context: ModelContext
    
    // MARK: - Init
    private init() {
        do {
            let schema = Schema([
                CVData.self,
                Experience.self,
                Education.self,
                Skill.self,
                LanguageSkill.self,
                Certificate.self,
                Project.self
            ])
            
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
            
            context = container.mainContext
            context.autosaveEnabled = true
            
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    // MARK: - CRUD Operations
    
    // MARK: Create
    /// إنشاء سيرة ذاتية جديدة
    func createCV(_ cv: CVData) throws {
        context.insert(cv)
        try save()
    }
    
    /// إنشاء سيرة ذاتية جديدة فارغة
    func createEmptyCV(name: String) throws -> CVData {
        let cv = CVData(cvName: name)
        context.insert(cv)
        try save()
        return cv
    }
    
    // MARK: Read
    /// جلب جميع السير الذاتية
    func fetchAllCVs() throws -> [CVData] {
        let descriptor = FetchDescriptor<CVData>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    /// جلب سيرة ذاتية بالمعرف
    func fetchCV(byId id: UUID) throws -> CVData? {
        let descriptor = FetchDescriptor<CVData>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    /// جلب السير الذاتية الأخيرة
    func fetchRecentCVs(limit: Int = 5) throws -> [CVData] {
        var descriptor = FetchDescriptor<CVData>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try context.fetch(descriptor)
    }
    
    /// البحث في السير الذاتية
    func searchCVs(query: String) throws -> [CVData] {
        let descriptor = FetchDescriptor<CVData>(
            predicate: #Predicate {
                $0.cvName.localizedStandardContains(query) ||
                $0.fullName.localizedStandardContains(query) ||
                $0.jobTitle.localizedStandardContains(query)
            },
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    // MARK: Update
    /// تحديث سيرة ذاتية
    func updateCV(_ cv: CVData) throws {
        cv.touch()
        try save()
    }
    
    // MARK: Delete
    /// حذف سيرة ذاتية
    func deleteCV(_ cv: CVData) throws {
        context.delete(cv)
        try save()
    }
    
    /// حذف سيرة ذاتية بالمعرف
    func deleteCV(byId id: UUID) throws {
        if let cv = try fetchCV(byId: id) {
            context.delete(cv)
            try save()
        }
    }
    
    /// حذف جميع السير الذاتية
    func deleteAllCVs() throws {
        let cvs = try fetchAllCVs()
        for cv in cvs {
            context.delete(cv)
        }
        try save()
    }
    
    // MARK: Experience Operations
    /// إضافة خبرة لسيرة ذاتية
    func addExperience(_ experience: Experience, to cv: CVData) throws {
        experience.sortOrder = cv.experiences.count
        cv.experiences.append(experience)
        cv.touch()
        try save()
    }
    
    /// حذف خبرة
    func deleteExperience(_ experience: Experience) throws {
        context.delete(experience)
        try save()
    }
    
    // MARK: Education Operations
    /// إضافة تعليم لسيرة ذاتية
    func addEducation(_ education: Education, to cv: CVData) throws {
        education.sortOrder = cv.educations.count
        cv.educations.append(education)
        cv.touch()
        try save()
    }
    
    /// حذف تعليم
    func deleteEducation(_ education: Education) throws {
        context.delete(education)
        try save()
    }
    
    // MARK: Skill Operations
    /// إضافة مهارة لسيرة ذاتية
    func addSkill(_ skill: Skill, to cv: CVData) throws {
        skill.sortOrder = cv.skills.count
        cv.skills.append(skill)
        cv.touch()
        try save()
    }
    
    /// حذف مهارة
    func deleteSkill(_ skill: Skill) throws {
        context.delete(skill)
        try save()
    }
    
    // MARK: Save
    /// حفظ التغييرات
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    // MARK: Statistics
    /// عدد السير الذاتية
    func cvCount() throws -> Int {
        let descriptor = FetchDescriptor<CVData>()
        return try context.fetchCount(descriptor)
    }
}

// MARK: - Preview Helper
extension DatabaseManager {
    /// إنشاء بيانات تجريبية للـ Preview
    func createSampleData() throws {
        // Check if already has data
        let count = try cvCount()
        if count > 0 { return }
        
        // Create sample CVs
        let cv1 = CVData(
            cvName: "Senior Product Designer",
            fullName: "Alex Morgan",
            jobTitle: "Senior Product Designer",
            email: "alex@example.com",
            phone: "+1 (555) 000-0000",
            location: "San Francisco, CA",
            summary: "Creative product designer with 5+ years of experience."
        )
        
        let cv2 = CVData(
            cvName: "Frontend Dev Resume",
            fullName: "Alex Morgan",
            jobTitle: "Frontend Developer",
            email: "alex@example.com",
            phone: "+1 (555) 000-0000",
            location: "San Francisco, CA"
        )
        cv2.updatedAt = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        
        let cv3 = CVData(
            cvName: "Marketing Manager CV",
            fullName: "Alex Morgan",
            jobTitle: "Marketing Manager",
            email: "alex@example.com"
        )
        cv3.updatedAt = Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
        
        try createCV(cv1)
        try createCV(cv2)
        try createCV(cv3)
    }
}
