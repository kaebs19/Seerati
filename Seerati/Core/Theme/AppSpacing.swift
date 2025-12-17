//
//  AppSpacing.swift
//  Seerati
//
//  Path: Seerati/Core/Theme/AppSpacing.swift
//

import SwiftUI

// MARK: - App Spacing
/// المسافات والأبعاد الموحدة في التطبيق
struct AppSpacing {
    
    // MARK: - Base Unit
    /// الوحدة الأساسية للمسافات (4px)
    static let unit: CGFloat = 4
    
    // MARK: - Spacing Values
    /// مسافة صغيرة جداً (4px)
    static let xxs: CGFloat = unit * 1      // 4
    
    /// مسافة صغيرة (8px)
    static let xs: CGFloat = unit * 2       // 8
    
    /// مسافة متوسطة صغيرة (12px)
    static let sm: CGFloat = unit * 3       // 12
    
    /// مسافة متوسطة (16px)
    static let md: CGFloat = unit * 4       // 16
    
    /// مسافة متوسطة كبيرة (20px)
    static let lg: CGFloat = unit * 5       // 20
    
    /// مسافة كبيرة (24px)
    static let xl: CGFloat = unit * 6       // 24
    
    /// مسافة كبيرة جداً (32px)
    static let xxl: CGFloat = unit * 8      // 32
    
    /// مسافة ضخمة (48px)
    static let xxxl: CGFloat = unit * 12    // 48
    
    // MARK: - Screen Padding
    /// حشوة الشاشة الأفقية
    static let screenHorizontal: CGFloat = 20
    
    /// حشوة الشاشة العلوية
    static let screenTop: CGFloat = 16
    
    /// حشوة الشاشة السفلية
    static let screenBottom: CGFloat = 32
    
    // MARK: - Component Spacing
    /// المسافة بين العناصر في القائمة
    static let listItemSpacing: CGFloat = 12
    
    /// المسافة بين الأقسام
    static let sectionSpacing: CGFloat = 24
    
    /// المسافة بين حقول الإدخال
    static let inputSpacing: CGFloat = 16
    
    /// المسافة داخل البطاقة
    static let cardPadding: CGFloat = 16
    
    /// المسافة بين البطاقات
    static let cardSpacing: CGFloat = 12
    
    // MARK: - Corner Radius
    /// زوايا صغيرة
    static let radiusSmall: CGFloat = 8
    
    /// زوايا متوسطة
    static let radiusMedium: CGFloat = 12
    
    /// زوايا كبيرة
    static let radiusLarge: CGFloat = 16
    
    /// زوايا كبيرة جداً
    static let radiusXLarge: CGFloat = 24
    
    /// زوايا دائرية كاملة
    static let radiusFull: CGFloat = 100
    
    // MARK: - Icon Sizes
    /// أيقونة صغيرة
    static let iconSmall: CGFloat = 16
    
    /// أيقونة متوسطة
    static let iconMedium: CGFloat = 24
    
    /// أيقونة كبيرة
    static let iconLarge: CGFloat = 32
    
    /// أيقونة كبيرة جداً
    static let iconXLarge: CGFloat = 48
    
    // MARK: - Button Heights
    /// ارتفاع الزر الصغير
    static let buttonHeightSmall: CGFloat = 36
    
    /// ارتفاع الزر المتوسط
    static let buttonHeightMedium: CGFloat = 48
    
    /// ارتفاع الزر الكبير
    static let buttonHeightLarge: CGFloat = 56
    
    // MARK: - Input Heights
    /// ارتفاع حقل الإدخال
    static let inputHeight: CGFloat = 52
    
    /// ارتفاع حقل الإدخال المتعدد الأسطر
    static let textAreaHeight: CGFloat = 120
    
    // MARK: - Avatar Sizes
    /// صورة شخصية صغيرة
    static let avatarSmall: CGFloat = 32
    
    /// صورة شخصية متوسطة
    static let avatarMedium: CGFloat = 48
    
    /// صورة شخصية كبيرة
    static let avatarLarge: CGFloat = 80
    
    /// صورة شخصية كبيرة جداً
    static let avatarXLarge: CGFloat = 120
}

// MARK: - EdgeInsets Extensions
extension EdgeInsets {
    /// حشوة الشاشة الافتراضية
    static let screenPadding = EdgeInsets(
        top: AppSpacing.screenTop,
        leading: AppSpacing.screenHorizontal,
        bottom: AppSpacing.screenBottom,
        trailing: AppSpacing.screenHorizontal
    )
    
    /// حشوة البطاقة
    static let cardPadding = EdgeInsets(
        top: AppSpacing.cardPadding,
        leading: AppSpacing.cardPadding,
        bottom: AppSpacing.cardPadding,
        trailing: AppSpacing.cardPadding
    )
    
    /// حشوة أفقية فقط
    static func horizontal(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: 0, leading: value, bottom: 0, trailing: value)
    }
    
    /// حشوة عمودية فقط
    static func vertical(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: 0, bottom: value, trailing: 0)
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: AppSpacing.lg) {
            // Spacing Demo
            Group {
                spacingRow("xxs (4)", AppSpacing.xxs)
                spacingRow("xs (8)", AppSpacing.xs)
                spacingRow("sm (12)", AppSpacing.sm)
                spacingRow("md (16)", AppSpacing.md)
                spacingRow("lg (20)", AppSpacing.lg)
                spacingRow("xl (24)", AppSpacing.xl)
            }
            
            Divider()
            
            // Radius Demo
            HStack(spacing: AppSpacing.md) {
                radiusBox("S", AppSpacing.radiusSmall)
                radiusBox("M", AppSpacing.radiusMedium)
                radiusBox("L", AppSpacing.radiusLarge)
                radiusBox("XL", AppSpacing.radiusXLarge)
            }
        }
        .padding()
    }
    .background(AppColors.background)
}

private func spacingRow(_ name: String, _ value: CGFloat) -> some View {
    HStack {
        Text(name)
            .font(AppFonts.caption())
            .foregroundStyle(AppColors.textSecondary)
            .frame(width: 80, alignment: .leading)
        
        Rectangle()
            .fill(AppColors.primary)
            .frame(width: value, height: 20)
        
        Spacer()
    }
}

private func radiusBox(_ name: String, _ radius: CGFloat) -> some View {
    RoundedRectangle(cornerRadius: radius)
        .fill(AppColors.surface)
        .frame(width: 60, height: 60)
        .overlay(
            Text(name)
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
        )
}
