//
//  PrimaryButton.swift
//  Seerati
//
//  Path: Seerati/Core/Components/PrimaryButton.swift
//
//  ─────────────────────────────────────────────
//  AR: زر رئيسي قابل لإعادة الاستخدام في كل التطبيق
//  EN: Reusable primary button component
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Primary Button
struct PrimaryButton: View {
    
    // MARK: - Properties
    let title: String
    let icon: String?
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    // MARK: - Init
    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.textOnPrimary))
                        .scaleEffect(0.9)
                } else {
                    Text(title)
                        .font(AppFonts.button())
                    
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .foregroundStyle(AppColors.textOnPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: AppSpacing.buttonHeightLarge)
            .background(
                isDisabled
                    ? AppColors.primary.opacity(0.5)
                    : AppColors.primary
            )
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        }
        .disabled(isDisabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppFonts.button())
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .foregroundStyle(AppColors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: AppSpacing.buttonHeightLarge)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.radiusMedium)
                    .stroke(AppColors.primary, lineWidth: 1.5)
            )
        }
    }
}

// MARK: - Icon Button
struct IconButton: View {
    
    let icon: String
    let size: CGFloat
    let action: () -> Void
    
    init(
        _ icon: String,
        size: CGFloat = 24,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size))
                .foregroundStyle(AppColors.textPrimary)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        PrimaryButton("Create & Continue", icon: "arrow.right") {
            print("Tapped")
        }
        
        PrimaryButton("Loading...", isLoading: true) {}
        
        PrimaryButton("Disabled", isDisabled: true) {}
        
        SecondaryButton("Secondary", icon: "square.and.arrow.up") {
            print("Secondary")
        }
        
        IconButton("gearshape.fill") {
            print("Settings")
        }
    }
    .padding()
    .background(AppColors.background)
}
