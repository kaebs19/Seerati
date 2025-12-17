//
//  AppTheme.swift
//  Seerati
//
//  Path: Seerati/Core/Theme/AppTheme.swift
//

import SwiftUI

// MARK: - App Theme
/// يجمع كل عناصر التصميم في مكان واحد
struct AppTheme {
    static let colors = AppColors.self
    static let fonts = AppFonts.self
    static let spacing = AppSpacing.self
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        static let medium = Shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        static let large = Shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
    }
    
    // MARK: - Animations
    struct Animations {
        static let quick = Animation.easeInOut(duration: 0.2)
        static let normal = Animation.easeInOut(duration: 0.3)
        static let slow = Animation.easeInOut(duration: 0.5)
        static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    }
}

// MARK: - Shadow Struct
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Shadow View Modifier
struct ShadowModifier: ViewModifier {
    let shadow: Shadow
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
    }
}

extension View {
    func appShadow(_ shadow: Shadow) -> some View {
        modifier(ShadowModifier(shadow: shadow))
    }
}

// MARK: - Common View Modifiers

/// Card Style Modifier
struct CardStyle: ViewModifier {
    var backgroundColor: Color = AppColors.surface
    var cornerRadius: CGFloat = AppSpacing.radiusMedium
    var padding: CGFloat = AppSpacing.cardPadding
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

/// Input Field Style Modifier
struct InputFieldStyle: ViewModifier {
    var isFocused: Bool = false
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(AppColors.inputBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.radiusMedium)
                    .stroke(
                        isFocused ? AppColors.borderFocused : Color.clear,
                        lineWidth: 1.5
                    )
            )
    }
}

// MARK: - View Extensions
extension View {
    /// تطبيق نمط البطاقة
    func cardStyle(
        backgroundColor: Color = AppColors.surface,
        cornerRadius: CGFloat = AppSpacing.radiusMedium,
        padding: CGFloat = AppSpacing.cardPadding
    ) -> some View {
        modifier(CardStyle(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            padding: padding
        ))
    }
    
    /// تطبيق نمط حقل الإدخال
    func inputFieldStyle(isFocused: Bool = false) -> some View {
        modifier(InputFieldStyle(isFocused: isFocused))
    }
    
    /// إخفاء لوحة المفاتيح
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    /// تطبيق خلفية التطبيق
    func appBackground() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }
    
    /// تطبيق حشوة الشاشة
    func screenPadding() -> some View {
        self.padding(.horizontal, AppSpacing.screenHorizontal)
    }
}

// MARK: - Button Styles

/// Primary Button Style
struct PrimaryButtonStyle: ButtonStyle {
    var isDisabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.button())
            .foregroundStyle(AppColors.textOnPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: AppSpacing.buttonHeightLarge)
            .background(
                isDisabled
                    ? AppColors.primary.opacity(0.5)
                    : AppColors.primary
            )
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Secondary Button Style
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.button())
            .foregroundStyle(AppColors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: AppSpacing.buttonHeightLarge)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.radiusMedium)
                    .stroke(AppColors.primary, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Ghost Button Style
struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppFonts.button())
            .foregroundStyle(AppColors.textPrimary)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
    static func primary(disabled: Bool) -> PrimaryButtonStyle {
        PrimaryButtonStyle(isDisabled: disabled)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle { SecondaryButtonStyle() }
}

extension ButtonStyle where Self == GhostButtonStyle {
    static var ghost: GhostButtonStyle { GhostButtonStyle() }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Card Example
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Title")
                .font(AppFonts.title3())
            Text("This is a card with the default style applied.")
                .font(AppFonts.body())
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
        
        // Buttons
        Button("Primary Button") {}
            .buttonStyle(.primary)
        
        Button("Secondary Button") {}
            .buttonStyle(.secondary)
        
        Button("Ghost Button") {}
            .buttonStyle(.ghost)
        
        // Input Field
        TextField("Placeholder", text: .constant(""))
            .inputFieldStyle()
    }
    .padding()
    .appBackground()
}
