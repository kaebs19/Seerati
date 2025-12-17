//
//  Certificate.swift
//  Seerati
//
//  Path: Seerati/Models/Certificate.swift
//

import Foundation
import SwiftData

// MARK: - Certificate Model
/// نموذج الشهادة
@Model
final class Certificate {
    
    // MARK: - Properties
    var id: UUID
    
    /// اسم الشهادة
    var name: String
    
    /// الجهة المانحة
    var issuer: String
    
    /// تاريخ الحصول
    var issueDate: Date
    
    /// تاريخ الانتهاء (اختياري)
    var expiryDate: Date?
    
    /// رابط الشهادة (اختياري)
    var credentialURL: String
    
    /// رقم الشهادة (اختياري)
    var credentialID: String
    
    /// ترتيب العرض
    var sortOrder: Int
    
    // MARK: - Relationship
    var cv: CVData?
    
    // MARK: - Init
    init(
        id: UUID = UUID(),
        name: String = "",
        issuer: String = "",
        issueDate: Date = Date(),
        expiryDate: Date? = nil,
        credentialURL: String = "",
        credentialID: String = "",
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.issuer = issuer
        self.issueDate = issueDate
        self.expiryDate = expiryDate
        self.credentialURL = credentialURL
        self.credentialID = credentialID
        self.sortOrder = sortOrder
    }
    
    // MARK: - Computed Properties
    /// هل الشهادة منتهية؟
    var isExpired: Bool {
        guard let expiry = expiryDate else { return false }
        return expiry < Date()
    }
    
    /// نص التاريخ
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: issueDate)
    }
}

// MARK: - Certificate Extensions
extension Certificate {
    static var preview: Certificate {
        Certificate(
            name: "AWS Solutions Architect",
            issuer: "Amazon Web Services",
            issueDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
            credentialID: "ABC123XYZ"
        )
    }
}
