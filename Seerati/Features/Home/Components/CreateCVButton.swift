//
//  CreateCVButton.swift
//  Seerati
//
//  Path: Seerati/Features/Home/Components/CreateCVButton.swift
//
//  ─────────────────────────────────────────────
//  AR: زر إنشاء سيرة ذاتية جديدة بارز
//  EN: Prominent create new CV button
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Create CV Button
struct CreateCVButton: View {
    
    // MARK: - Properties
    var onTap: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(HomeStrings.createNewCV)
                        .font(AppFonts.title3())
                        .foregroundStyle(AppColors.textOnPrimary)
                    
                    Text(HomeStrings.startFromScratch)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textOnPrimary.opacity(0.8))
                }
                
                Spacer()
                
                // Plus Icon
                PlusIconView()
            }
            .padding(AppSpacing.lg)
            .background(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusLarge))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Plus Icon View
struct PlusIconView: View {
    
    var size: CGFloat = 40
    var backgroundColor: Color = AppColors.textOnPrimary.opacity(0.2)
    var iconColor: Color = AppColors.textOnPrimary
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
            
            Image(systemName: "plus")
                .font(.system(size: size * 0.45, weight: .semibold))
                .foregroundStyle(iconColor)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack {
        CreateCVButton {
            print("Create tapped")
        }
    }
    .padding()
    .background(AppColors.background)
}
