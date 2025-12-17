//
//  AppFonts.swift
//  Seerati
//
//  Path: Seerati/Core/Theme/AppFonts.swift
//

import SwiftUI

// MARK: - App Fonts
/// خطوط التطبيق وأحجامها
struct AppFonts {
    
    // MARK: - Font Names
    /// اسم الخط الرئيسي (يمكن تغييره لخط مخصص)
    static let primaryFont = "System"
    
    /// اسم الخط العربي
    static let arabicFont = "System"
    
    // MARK: - Title Fonts
    /// عنوان كبير جداً (الشاشة الرئيسية)
    static func largeTitle(weight: Font.Weight = .bold) -> Font {
        .system(size: 34, weight: weight, design: .default)
    }
    
    /// عنوان الصفحة
    static func title(weight: Font.Weight = .bold) -> Font {
        .system(size: 28, weight: weight, design: .default)
    }
    
    /// عنوان ثانوي
    static func title2(weight: Font.Weight = .semibold) -> Font {
        .system(size: 22, weight: weight, design: .default)
    }
    
    /// عنوان صغير
    static func title3(weight: Font.Weight = .semibold) -> Font {
        .system(size: 20, weight: weight, design: .default)
    }
    
    // MARK: - Body Fonts
    /// النص الرئيسي
    static func body(weight: Font.Weight = .regular) -> Font {
        .system(size: 17, weight: weight, design: .default)
    }
    
    /// النص الثانوي
    static func callout(weight: Font.Weight = .regular) -> Font {
        .system(size: 16, weight: weight, design: .default)
    }
    
    /// نص فرعي
    static func subheadline(weight: Font.Weight = .regular) -> Font {
        .system(size: 15, weight: weight, design: .default)
    }
    
    /// حاشية
    static func footnote(weight: Font.Weight = .regular) -> Font {
        .system(size: 13, weight: weight, design: .default)
    }
    
    // MARK: - Small Fonts
    /// نص صغير
    static func caption(weight: Font.Weight = .regular) -> Font {
        .system(size: 12, weight: weight, design: .default)
    }
    
    /// نص صغير جداً
    static func caption2(weight: Font.Weight = .regular) -> Font {
        .system(size: 11, weight: weight, design: .default)
    }
    
    // MARK: - Special Fonts
    /// نص الزر
    static func button(weight: Font.Weight = .semibold) -> Font {
        .system(size: 17, weight: weight, design: .default)
    }
    
    /// تسمية حقل الإدخال
    static func inputLabel(weight: Font.Weight = .medium) -> Font {
        .system(size: 12, weight: weight, design: .default)
    }
    
    /// نص حقل الإدخال
    static func inputText(weight: Font.Weight = .regular) -> Font {
        .system(size: 16, weight: weight, design: .default)
    }
    
    /// رقم كبير
    static func largeNumber(weight: Font.Weight = .bold) -> Font {
        .system(size: 48, weight: weight, design: .rounded)
    }
}

// MARK: - Font Size Constants
extension AppFonts {
    enum Size {
        static let largeTitle: CGFloat = 34
        static let title: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subheadline: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption: CGFloat = 12
        static let caption2: CGFloat = 11
    }
}

// MARK: - Text Style Modifier
struct AppTextStyle: ViewModifier {
    let font: Font
    let color: Color
    let lineSpacing: CGFloat
    
    init(
        font: Font = AppFonts.body(),
        color: Color = AppColors.textPrimary,
        lineSpacing: CGFloat = 4
    ) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
    }
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .lineSpacing(lineSpacing)
    }
}

// MARK: - View Extension
extension View {
    func appTextStyle(
        font: Font = AppFonts.body(),
        color: Color = AppColors.textPrimary,
        lineSpacing: CGFloat = 4
    ) -> some View {
        modifier(AppTextStyle(font: font, color: color, lineSpacing: lineSpacing))
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Text("Large Title")
                .font(AppFonts.largeTitle())
            
            Text("Title")
                .font(AppFonts.title())
            
            Text("Title 2")
                .font(AppFonts.title2())
            
            Text("Title 3")
                .font(AppFonts.title3())
            
            Divider()
            
            Text("Body Text")
                .font(AppFonts.body())
            
            Text("Callout Text")
                .font(AppFonts.callout())
            
            Text("Subheadline")
                .font(AppFonts.subheadline())
            
            Text("Footnote")
                .font(AppFonts.footnote())
            
            Text("Caption")
                .font(AppFonts.caption())
            
            Divider()
            
            Text("Button Text")
                .font(AppFonts.button())
            
            Text("INPUT LABEL")
                .font(AppFonts.inputLabel())
        }
        .padding()
        .foregroundStyle(AppColors.textPrimary)
    }
    .background(AppColors.background)
}
