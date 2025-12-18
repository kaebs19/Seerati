//
//  PersonalInfoEnums.swift
//  Seerati
//
//  Path: Seerati/Models/PersonalInfoEnums.swift
//
//  ─────────────────────────────────────────────────
//  AR: تعدادات المعلومات الشخصية
//  EN: Personal Information Enums
//  ─────────────────────────────────────────────────

import Foundation

// MARK: - Gender
/// الجنس
enum Gender: String, CaseIterable, Codable {
    case male = "male"
    case female = "female"
    case preferNotToSay = "prefer_not_to_say"
    
    var localizedName: String {
        switch self {
        case .male:
            return NSLocalizedString("ذكر", comment: "Male")
        case .female:
            return NSLocalizedString("أنثى", comment: "Female")
        case .preferNotToSay:
            return NSLocalizedString("أفضل عدم الإفصاح", comment: "Prefer not to say")
        }
    }
    
    var englishName: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        case .preferNotToSay: return "Prefer not to say"
        }
    }
}

// MARK: - Marital Status
/// الحالة الاجتماعية
enum MaritalStatus: String, CaseIterable, Codable {
    case single = "single"
    case married = "married"
    case divorced = "divorced"
    case widowed = "widowed"
    case preferNotToSay = "prefer_not_to_say"
    
    var localizedName: String {
        switch self {
        case .single:
            return NSLocalizedString("أعزب/عزباء", comment: "Single")
        case .married:
            return NSLocalizedString("متزوج/ة", comment: "Married")
        case .divorced:
            return NSLocalizedString("مطلق/ة", comment: "Divorced")
        case .widowed:
            return NSLocalizedString("أرمل/ة", comment: "Widowed")
        case .preferNotToSay:
            return NSLocalizedString("أفضل عدم الإفصاح", comment: "Prefer not to say")
        }
    }
    
    var englishName: String {
        switch self {
        case .single: return "Single"
        case .married: return "Married"
        case .divorced: return "Divorced"
        case .widowed: return "Widowed"
        case .preferNotToSay: return "Prefer not to say"
        }
    }
}

// MARK: - Driving License
/// رخصة القيادة
enum DrivingLicense: String, CaseIterable, Codable {
    case none = "none"
    case car = "car"
    case motorcycle = "motorcycle"
    case truck = "truck"
    case international = "international"
    
    var localizedName: String {
        switch self {
        case .none:
            return NSLocalizedString("لا يوجد", comment: "None")
        case .car:
            return NSLocalizedString("سيارة خاصة", comment: "Car")
        case .motorcycle:
            return NSLocalizedString("دراجة نارية", comment: "Motorcycle")
        case .truck:
            return NSLocalizedString("شاحنة/نقل ثقيل", comment: "Truck")
        case .international:
            return NSLocalizedString("رخصة دولية", comment: "International")
        }
    }
    
    var englishName: String {
        switch self {
        case .none: return "None"
        case .car: return "Valid Driver's License"
        case .motorcycle: return "Motorcycle License"
        case .truck: return "Commercial/Truck License"
        case .international: return "International License"
        }
    }
}

// MARK: - Visa Status
/// حالة الإقامة/التأشيرة
enum VisaStatus: String, CaseIterable, Codable {
    case citizen = "citizen"
    case resident = "resident"
    case workVisa = "work_visa"
    case visitVisa = "visit_visa"
    case transferable = "transferable"
    case needsSponsorship = "needs_sponsorship"
    
    var localizedName: String {
        switch self {
        case .citizen:
            return NSLocalizedString("مواطن", comment: "Citizen")
        case .resident:
            return NSLocalizedString("مقيم", comment: "Resident")
        case .workVisa:
            return NSLocalizedString("تأشيرة عمل", comment: "Work Visa")
        case .visitVisa:
            return NSLocalizedString("تأشيرة زيارة", comment: "Visit Visa")
        case .transferable:
            return NSLocalizedString("إقامة قابلة للنقل", comment: "Transferable")
        case .needsSponsorship:
            return NSLocalizedString("يحتاج كفالة", comment: "Needs Sponsorship")
        }
    }
    
    var englishName: String {
        switch self {
        case .citizen: return "Citizen"
        case .resident: return "Permanent Resident"
        case .workVisa: return "Work Visa"
        case .visitVisa: return "Visit Visa"
        case .transferable: return "Transferable Iqama"
        case .needsSponsorship: return "Requires Sponsorship"
        }
    }
}

// MARK: - Common Nationalities
/// الجنسيات الشائعة
enum CommonNationality: String, CaseIterable {
    // الخليج
    case saudi = "Saudi"
    case emirati = "Emirati"
    case kuwaiti = "Kuwaiti"
    case qatari = "Qatari"
    case bahraini = "Bahraini"
    case omani = "Omani"
    
    // العربية
    case egyptian = "Egyptian"
    case jordanian = "Jordanian"
    case lebanese = "Lebanese"
    case syrian = "Syrian"
    case palestinian = "Palestinian"
    case iraqi = "Iraqi"
    case yemeni = "Yemeni"
    case sudanese = "Sudanese"
    case moroccan = "Moroccan"
    case tunisian = "Tunisian"
    case algerian = "Algerian"
    
    // آسيا
    case indian = "Indian"
    case pakistani = "Pakistani"
    case bangladeshi = "Bangladeshi"
    case filipino = "Filipino"
    case indonesian = "Indonesian"
    
    // أخرى
    case american = "American"
    case british = "British"
    case other = "Other"
    
    var localizedName: String {
        switch self {
        case .saudi: return "سعودي"
        case .emirati: return "إماراتي"
        case .kuwaiti: return "كويتي"
        case .qatari: return "قطري"
        case .bahraini: return "بحريني"
        case .omani: return "عماني"
        case .egyptian: return "مصري"
        case .jordanian: return "أردني"
        case .lebanese: return "لبناني"
        case .syrian: return "سوري"
        case .palestinian: return "فلسطيني"
        case .iraqi: return "عراقي"
        case .yemeni: return "يمني"
        case .sudanese: return "سوداني"
        case .moroccan: return "مغربي"
        case .tunisian: return "تونسي"
        case .algerian: return "جزائري"
        case .indian: return "هندي"
        case .pakistani: return "باكستاني"
        case .bangladeshi: return "بنغلاديشي"
        case .filipino: return "فلبيني"
        case .indonesian: return "إندونيسي"
        case .american: return "أمريكي"
        case .british: return "بريطاني"
        case .other: return "أخرى"
        }
    }
}
