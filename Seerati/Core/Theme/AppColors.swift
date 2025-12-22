//
//  AppColors.swift
//  Seerati
//
//  Path: Seerati/Core/Theme/AppColors.swift
//

import SwiftUI

// MARK: - App Colors

/// ألوان التطبيق الرئيسية مستوحاة من التصميم
struct AppColors {
    
    // MARK: - Primary Colors
    static let primary = Color(hex: "4ADE80")
    static let primaryLight = Color(hex: "86EFAC")
    static let primaryDark = Color(hex: "22C55E")
    
    // MARK: - Background Colors (متكيفة)
    static var background: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(hex: "0D1F17")
                : UIColor(hex: "F8F9FA")
        })
    }
    
    static var surface: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(hex: "1A3D2E")
                : UIColor.white
        })
    }
    
    static var inputBackground: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(hex: "1E4D3D")
                : UIColor(hex: "F3F4F6")
        })
    }
    
    static var surfaceLight: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(hex: "2D5A47")
                : UIColor(hex: "E5E7EB")
        })
    }
    
    // MARK: - Text Colors (متكيفة) ✅
    static var textPrimary: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor.white
                : UIColor(hex: "111827")
        })
    }
    
    static var textSecondary: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(hex: "9CA3AF")
                : UIColor(hex: "6B7280")
        })
    }
    
    static var textDisabled: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(hex: "6B7280")
                : UIColor(hex: "9CA3AF")
        })
    }
    
    static let textOnPrimary = Color(hex: "0D1F17")
    
    // MARK: - Semantic Colors
    static let success = Color(hex: "4ADE80")
    static let warning = Color(hex: "FBBF24")
    static let error = Color(hex: "EF4444")
    static let info = Color(hex: "3B82F6")
    
    // MARK: - Border Colors (متكيفة)
    static var border: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(hex: "2D5A47")
                : UIColor(hex: "E5E7EB")
        })
    }
    
    static let borderFocused = Color(hex: "4ADE80")
    
    // MARK: - Overlay Colors
    static let overlayDark = Color.black.opacity(0.5)
    static let overlayLight = Color.white.opacity(0.1)
    
    // MARK: - Gradient
    static let primaryGradient = LinearGradient(
        colors: [primaryLight, primary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [background, surface],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// تحويل اللون إلى Hex String
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            Group {
                colorRow("Primary", AppColors.primary)
                colorRow("Primary Light", AppColors.primaryLight)
                colorRow("Background", AppColors.background)
                colorRow("Surface", AppColors.surface)
                colorRow("Input BG", AppColors.inputBackground)
            }
            
            Divider()
            
            Group {
                colorRow("Text Primary", AppColors.textPrimary)
                colorRow("Text Secondary", AppColors.textSecondary)
                colorRow("Border", AppColors.border)
            }
        }
        .padding()
    }
    .background(AppColors.background)
}

private func colorRow(_ name: String, _ color: Color) -> some View {
    HStack {
        RoundedRectangle(cornerRadius: 8)
            .fill(color)
            .frame(width: 50, height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        Text(name)
            .foregroundStyle(.white)
        Spacer()
    }
}
