//
//  Language.swift
//  Seerati
//
//  Path: Seerati/Core/Localization/Language.swift
//

import SwiftUI

// MARK: - Language Enum
/// اللغات المدعومة في التطبيق
enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case arabic = "ar"
    
    var id: String { rawValue }
    
    /// اسم اللغة بلغتها الأصلية
    var nativeName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        }
    }
    
    /// اسم اللغة بالإنجليزية
    var englishName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "Arabic"
        }
    }
    
    /// هل اللغة من اليمين لليسار؟
    var isRTL: Bool {
        self == .arabic
    }
    
    /// اتجاه التخطيط
    var layoutDirection: LayoutDirection {
        isRTL ? .rightToLeft : .leftToRight
    }
    
    /// رمز العلم (Emoji)
    var flagEmoji: String {
        switch self {
        case .english: return "🇺🇸"
        case .arabic: return "🇸🇦"
        }
    }
    
    /// اللغة الافتراضية
    static var `default`: Language {
        // تحديد اللغة بناءً على لغة الجهاز
        let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        return Language(rawValue: deviceLanguage) ?? .english
    }
}

// MARK: - Locale Extensions
extension Language {
    /// الـ Locale الخاص باللغة
    var locale: Locale {
        Locale(identifier: rawValue)
    }
    
    /// تنسيق التاريخ
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        return formatter
    }
}
