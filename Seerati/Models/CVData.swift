//
//  CVData.swift
//  Seerati
//
//  Path: Seerati/Models/CVData.swift
//
//  ─────────────────────────────────────────────────
//  AR: نموذج بيانات السيرة الذاتية المحدث
//  EN: Updated CV Data Model with Personal Info
//  ─────────────────────────────────────────────────

import Foundation
import SwiftData

// MARK: - CV Data Model
@Model
final class CVData {
    
    // MARK: - Basic Properties
    var id: UUID
    var cvName: String
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Personal Information
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
    
    /// الموقع الإلكتروني
    var website: String
    
    /// رابط LinkedIn
    var linkedin: String
    
    /// الملخص الشخصي
    var summary: String
    
    /// الصورة الشخصية
    @Attribute(.externalStorage)
    var photoData: Data?
    
    // ═══════════════════════════════════════════
    // MARK: - ✅ NEW: Additional Personal Info
    // ═══════════════════════════════════════════
    
    /// تاريخ الميلاد
    var dateOfBirth: Date?
    
    /// الجنسية
    var nationality: String
    
    /// الجنس
    var genderRaw: String
    
    /// الحالة الاجتماعية
    var maritalStatusRaw: String
    
    /// رخصة القيادة
    var drivingLicenseRaw: String
    
    /// حالة الإقامة/التأشيرة
    var visaStatusRaw: String
    
    // ═══════════════════════════════════════════
    // MARK: - ✅ NEW: Visibility Settings
    // ═══════════════════════════════════════════
    
    /// إظهار تاريخ الميلاد
    var showDateOfBirth: Bool
    
    /// إظهار الجنسية
    var showNationality: Bool
    
    /// إظهار الجنس
    var showGender: Bool
    
    /// إظهار الحالة الاجتماعية
    var showMaritalStatus: Bool
    
    /// إظهار رخصة القيادة
    var showDrivingLicense: Bool
    
    /// إظهار حالة الإقامة
    var showVisaStatus: Bool
    
    // MARK: - Relationships
    @Relationship(deleteRule: .cascade, inverse: \Experience.cv)
    var experiences: [Experience]
    
    @Relationship(deleteRule: .cascade, inverse: \Education.cv)
    var educations: [Education]
    
    @Relationship(deleteRule: .cascade, inverse: \Skill.cv)
    var skills: [Skill]
    
    // MARK: - Template
    var selectedTemplateId: String
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        cvName: String = "",
        fullName: String = "",
        jobTitle: String = "",
        email: String = "",
        phone: String = "",
        location: String = "",
        website: String = "",
        linkedin: String = "",
        summary: String = "",
        photoData: Data? = nil,
        // New fields
        dateOfBirth: Date? = nil,
        nationality: String = "",
        gender: Gender = .preferNotToSay,
        maritalStatus: MaritalStatus = .preferNotToSay,
        drivingLicense: DrivingLicense = .none,
        visaStatus: VisaStatus = .citizen,
        // Visibility
        showDateOfBirth: Bool = true,
        showNationality: Bool = true,
        showGender: Bool = false,
        showMaritalStatus: Bool = false,
        showDrivingLicense: Bool = false,
        showVisaStatus: Bool = false,
        // Other
        selectedTemplateId: String = "swiss_minimal"
    ) {
        self.id = id
        self.cvName = cvName
        self.createdAt = Date()
        self.updatedAt = Date()
        self.fullName = fullName
        self.jobTitle = jobTitle
        self.email = email
        self.phone = phone
        self.location = location
        self.website = website
        self.linkedin = linkedin
        self.summary = summary
        self.photoData = photoData
        // New fields
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
        self.genderRaw = gender.rawValue
        self.maritalStatusRaw = maritalStatus.rawValue
        self.drivingLicenseRaw = drivingLicense.rawValue
        self.visaStatusRaw = visaStatus.rawValue
        // Visibility
        self.showDateOfBirth = showDateOfBirth
        self.showNationality = showNationality
        self.showGender = showGender
        self.showMaritalStatus = showMaritalStatus
        self.showDrivingLicense = showDrivingLicense
        self.showVisaStatus = showVisaStatus
        // Other
        self.selectedTemplateId = selectedTemplateId
        self.experiences = []
        self.educations = []
        self.skills = []
    }
    
    // MARK: - Computed Properties for Enums
    
    var gender: Gender {
        get { Gender(rawValue: genderRaw) ?? .preferNotToSay }
        set { genderRaw = newValue.rawValue }
    }
    
    var maritalStatus: MaritalStatus {
        get { MaritalStatus(rawValue: maritalStatusRaw) ?? .preferNotToSay }
        set { maritalStatusRaw = newValue.rawValue }
    }
    
    var drivingLicense: DrivingLicense {
        get { DrivingLicense(rawValue: drivingLicenseRaw) ?? .none }
        set { drivingLicenseRaw = newValue.rawValue }
    }
    
    var visaStatus: VisaStatus {
        get { VisaStatus(rawValue: visaStatusRaw) ?? .citizen }
        set { visaStatusRaw = newValue.rawValue }
    }
    
    // MARK: - Age Calculation
    var age: Int? {
        guard let dob = dateOfBirth else { return nil }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dob, to: Date())
        return ageComponents.year
    }
    
    /// تاريخ الميلاد منسق
    var formattedDateOfBirth: String {
        guard let dob = dateOfBirth else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ar")
        return formatter.string(from: dob)
    }
    
    // MARK: - Update Timestamp
    func markAsUpdated() {
        self.updatedAt = Date()
    }
    
    // MARK: - Computed Properties

    /// تحديث التاريخ (alias لـ markAsUpdated)
    func touch() {
        self.updatedAt = Date()
    }

    /// معرف القالب (alias لـ selectedTemplateId)
    var templateId: String {
        get { selectedTemplateId }
        set { selectedTemplateId = newValue }
    }

    /// نص آخر تعديل
    var lastEditedText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.unitsStyle = .short
        return formatter.localizedString(for: updatedAt, relativeTo: Date())
    }

    /// نص تاريخ الإنشاء
    var createdAtText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ar")
        return formatter.string(from: createdAt)
    }
}

// MARK: - Preview
extension CVData {
    static var preview: CVData {
        let cv = CVData(
            cvName: "سيرتي الذاتية",
            fullName: "أحمد محمد الراشد",
            jobTitle: "مطور تطبيقات iOS",
            email: "ahmed@example.com",
            phone: "+966 50 000 0000",
            location: "الرياض، السعودية",
            website: "www.ahmed.dev",
            linkedin: "linkedin.com/in/ahmed",
            summary: "مطور iOS محترف مع خبرة 5 سنوات في بناء تطبيقات عالية الجودة باستخدام Swift و SwiftUI.",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -28, to: Date()),
            nationality: "سعودي",
            gender: .male,
            maritalStatus: .single,
            drivingLicense: .car,
            visaStatus: .citizen,
            showDateOfBirth: true,
            showNationality: true
        )
        return cv
    }
}
