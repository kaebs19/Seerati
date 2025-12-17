//
//  Template.swift
//  Seerati
//
//  Path: Seerati/Models/Template.swift
//

import SwiftUI

// MARK: - Template Model
/// نموذج قالب السيرة الذاتية
struct Template: Identifiable, Hashable {
    
    // MARK: - Properties
    let id: String
    let name: String
    let nameArabic: String
    let description: String
    let descriptionArabic: String
    let category: TemplateCategory
    let isPremium: Bool
    let isNew: Bool
    let previewImageName: String
    let primaryColor: Color
    
    // MARK: - Computed Properties
    /// الاسم حسب اللغة
    var localizedName: String {
        LocalizationManager.shared.isArabic ? nameArabic : name
    }
    
    /// الوصف حسب اللغة
    var localizedDescription: String {
        LocalizationManager.shared.isArabic ? descriptionArabic : description
    }
}

// MARK: - Template Category
enum TemplateCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case minimal = "Minimal"
    case professional = "Professional"
    case creative = "Creative"
    case modern = "Modern"
    
    var id: String { rawValue }
    
    var arabicName: String {
        switch self {
        case .all: return "الكل"
        case .minimal: return "بسيط"
        case .professional: return "احترافي"
        case .creative: return "إبداعي"
        case .modern: return "عصري"
        }
    }
    
    var localizedName: String {
        LocalizationManager.shared.isArabic ? arabicName : rawValue
    }
}

// MARK: - Available Templates
extension Template {
    
    /// جميع القوالب المتاحة
    static let allTemplates: [Template] = [
        // Minimal Templates
        Template(
            id: "swiss_minimal",
            name: "Swiss Minimal",
            nameArabic: "سويسري بسيط",
            description: "Professional",
            descriptionArabic: "احترافي",
            category: .minimal,
            isPremium: false,  // ✅ القالب المجاني الوحيد
            isNew: false,
            previewImageName: "template_swiss",
            primaryColor: .black
        ),
        
        Template(
            id: "mono_focus",
            name: "Mono Focus",
            nameArabic: "تركيز أحادي",
            description: "Basic",
            descriptionArabic: "أساسي",
            category: .minimal,
            isPremium: true,  // 💰 مدفوع
            isNew: false,
            previewImageName: "template_mono",
            primaryColor: .gray
        ),
        
        // Professional Templates
        Template(
            id: "dark_sidebar",
            name: "Dark Sidebar",
            nameArabic: "شريط جانبي داكن",
            description: "Tech",
            descriptionArabic: "تقني",
            category: .professional,
            isPremium: true,  // 💰 مدفوع
            isNew: true,
            previewImageName: "template_dark",
            primaryColor: Color(hex: "1E3A5F")
        ),
        
        Template(
            id: "executive",
            name: "Executive",
            nameArabic: "تنفيذي",
            description: "Corporate",
            descriptionArabic: "شركات",
            category: .professional,
            isPremium: true,  // 💰 مدفوع
            isNew: false,
            previewImageName: "template_executive",
            primaryColor: Color(hex: "1E3A8A")
        ),
        
        Template(
            id: "serif_classic",
            name: "Serif Classic",
            nameArabic: "كلاسيكي",
            description: "Traditional",
            descriptionArabic: "تقليدي",
            category: .professional,
            isPremium: true,  // 💰 مدفوع
            isNew: false,
            previewImageName: "template_serif",
            primaryColor: Color(hex: "4A5568")
        ),
        
        // Creative Templates
        Template(
            id: "bold_type",
            name: "Bold Type",
            nameArabic: "خط عريض",
            description: "Creative",
            descriptionArabic: "إبداعي",
            category: .creative,
            isPremium: true,  // 💰 مدفوع
            isNew: false,
            previewImageName: "template_bold",
            primaryColor: Color(hex: "E53E3E")
        ),
        
        Template(
            id: "split_column",
            name: "Split Column",
            nameArabic: "عمودين",
            description: "Modern",
            descriptionArabic: "عصري",
            category: .modern,
            isPremium: true,  // 💰 مدفوع
            isNew: false,
            previewImageName: "template_split",
            primaryColor: Color(hex: "38A169")
        ),
        
        // Modern Templates
        Template(
            id: "the_modernist",
            name: "The Modernist",
            nameArabic: "المعاصر",
            description: "Trending",
            descriptionArabic: "رائج",
            category: .modern,
            isPremium: true,  // 💰 مدفوع
            isNew: false,
            previewImageName: "template_modernist",
            primaryColor: Color(hex: "805AD5")
        )
    ]
    
    /// القوالب المجانية فقط
    static var freeTemplates: [Template] {
        allTemplates.filter { !$0.isPremium }
    }
    
    /// القوالب المميزة
    static var premiumTemplates: [Template] {
        allTemplates.filter { $0.isPremium }
    }
    
    /// القوالب المميزة (Featured)
    static var featuredTemplates: [Template] {
        allTemplates.filter { $0.id == "the_modernist" || $0.id == "executive" }
    }
    
    /// القوالب الجديدة
    static var newTemplates: [Template] {
        allTemplates.filter { $0.isNew }
    }
    
    /// البحث عن قالب بالمعرف
    static func find(byId id: String) -> Template? {
        allTemplates.first { $0.id == id }
    }
    
    /// فلترة حسب الفئة
    static func filter(by category: TemplateCategory) -> [Template] {
        if category == .all {
            return allTemplates
        }
        return allTemplates.filter { $0.category == category }
    }
}

// MARK: - Preview Template
extension Template {
    static var preview: Template {
        allTemplates.first!
    }
}
