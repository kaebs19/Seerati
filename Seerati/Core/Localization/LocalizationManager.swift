//
//  LocalizationManager.swift
//  Seerati
//
//  Path: Seerati/Core/Localization/LocalizationManager.swift
//

import SwiftUI

// MARK: - Localization Manager
/// مدير الترجمة واللغات
@Observable
final class LocalizationManager {
    
    // MARK: - Singleton
    static let shared = LocalizationManager()
    
    // MARK: - Properties
    /// اللغة الحالية
    var currentLanguage: Language {
        didSet {
            saveLanguage()
            updateLayoutDirection()
        }
    }
    
    /// هل اللغة الحالية عربية؟
    var isArabic: Bool {
        currentLanguage == .arabic
    }
    
    /// هل اللغة الحالية إنجليزية؟
    var isEnglish: Bool {
        currentLanguage == .english
    }
    
    /// اتجاه التخطيط الحالي
    var layoutDirection: LayoutDirection {
        currentLanguage.layoutDirection
    }
    
    // MARK: - Private Properties
    private let languageKey = "app_language"
    
    // MARK: - Init
    private init() {
        // استرجاع اللغة المحفوظة أو استخدام الافتراضية
        if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
           let language = Language(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = Language.default
        }
    }
    
    // MARK: - Methods
    /// تغيير اللغة
    func setLanguage(_ language: Language) {
        currentLanguage = language
    }
    
    /// تبديل اللغة
    func toggleLanguage() {
        currentLanguage = currentLanguage == .arabic ? .english : .arabic
    }
    
    /// حفظ اللغة
    private func saveLanguage() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
    }
    
    /// تحديث اتجاه التخطيط
    private func updateLayoutDirection() {
        // تحديث اتجاه الواجهة
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.semanticContentAttribute = currentLanguage.isRTL ? .forceRightToLeft : .forceLeftToRight
            }
        }
    }
}

// MARK: - Localized String Protocol
/// بروتوكول للنصوص المترجمة
protocol LocalizedStrings {
    static var shared: Self { get }
}

// MARK: - String Localization Extension
extension String {
    /// ترجمة النص
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    /// ترجمة النص مع متغيرات
    func localized(with arguments: CVarArg...) -> String {
        String(format: self.localized, arguments: arguments)
    }
}

// MARK: - View Modifier for RTL Support
struct RTLSupportModifier: ViewModifier {
    @Environment(\.layoutDirection) var layoutDirection
    
    func body(content: Content) -> some View {
        content
            .environment(\.layoutDirection, LocalizationManager.shared.layoutDirection)
    }
}

extension View {
    /// تطبيق دعم RTL
    func rtlSupport() -> some View {
        modifier(RTLSupportModifier())
    }
    
    /// عكس الاتجاه إذا كانت اللغة عربية
    func flipIfRTL() -> some View {
        self.scaleEffect(x: LocalizationManager.shared.isArabic ? -1 : 1, y: 1)
    }
}

// MARK: - Alignment Extensions for RTL
extension HorizontalAlignment {
    /// البداية حسب اللغة
    static var languageLeading: HorizontalAlignment {
        LocalizationManager.shared.isArabic ? .trailing : .leading
    }
    
    /// النهاية حسب اللغة
    static var languageTrailing: HorizontalAlignment {
        LocalizationManager.shared.isArabic ? .leading : .trailing
    }
}

extension Alignment {
    /// بداية اللغة
    static var languageLeading: Alignment {
        LocalizationManager.shared.isArabic ? .trailing : .leading
    }
    
    /// نهاية اللغة
    static var languageTrailing: Alignment {
        LocalizationManager.shared.isArabic ? .leading : .trailing
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        Text("Current Language: \(LocalizationManager.shared.currentLanguage.nativeName)")
        
        Button("Toggle Language") {
            LocalizationManager.shared.toggleLanguage()
        }
        .buttonStyle(.primary)
        
        Text("Is RTL: \(LocalizationManager.shared.isArabic ? "Yes" : "No")")
    }
    .padding()
    .rtlSupport()
}
