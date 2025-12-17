//
//  CVCard.swift
//  Seerati
//
//  Path: Seerati/Core/Components/CVCard.swift
//
//  ─────────────────────────────────────────────
//  AR: بطاقة عرض السيرة الذاتية في القائمة
//  EN: CV display card for list view
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - CV Card
struct CVCard: View {
    
    // MARK: - Properties
    let cv: CVData
    var onTap: () -> Void
    var onMenuTap: (() -> Void)? = nil
    
    // MARK: - Body
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                // CV Icon
                CVIconView(color: AppColors.primary)
                
                // Info
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(cv.cvName.isEmpty ? "Untitled CV" : cv.cvName)
                        .font(AppFonts.body(weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text("Edited \(cv.lastEditedText)")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
                
                // Menu Button
                if let onMenuTap = onMenuTap {
                    Button(action: onMenuTap) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(AppColors.textSecondary)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - CV Icon View
struct CVIconView: View {
    
    var color: Color = AppColors.primary
    var size: CGFloat = 48
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.25)
                .fill(color.opacity(0.15))
                .frame(width: size, height: size)
            
            Image(systemName: "doc.text.fill")
                .font(.system(size: size * 0.4))
                .foregroundStyle(color)
        }
    }
}

// MARK: - Create CV Card
struct CreateCVCard: View {
    
    let title: String
    let subtitle: String
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(title)
                        .font(AppFonts.title3())
                        .foregroundStyle(AppColors.textOnPrimary)
                    
                    Text(subtitle)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textOnPrimary.opacity(0.8))
                }
                
                Spacer()
                
                // Plus Icon
                ZStack {
                    Circle()
                        .fill(AppColors.textOnPrimary.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(AppColors.textOnPrimary)
                }
            }
            .padding(AppSpacing.lg)
            .background(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusLarge))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Empty State Card
struct EmptyStateCard: View {
    
    let icon: String
    let title: String
    let message: String
    var buttonTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(AppColors.textSecondary)
            
            Text(title)
                .font(AppFonts.title3())
                .foregroundStyle(AppColors.textPrimary)
            
            Text(message)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            if let buttonTitle = buttonTitle, let action = action {
                PrimaryButton(buttonTitle, action: action)
                    .frame(width: 200)
            }
        }
        .padding(AppSpacing.xxl)
        .frame(maxWidth: .infinity)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusLarge))
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            CreateCVCard(
                title: "Create New CV",
                subtitle: "Start from scratch or template"
            ) {
                print("Create tapped")
            }
            
            CVCard(
                cv: CVData.preview,
                onTap: { print("CV tapped") },
                onMenuTap: { print("Menu tapped") }
            )
            
            EmptyStateCard(
                icon: "doc.text",
                title: "No CVs Yet",
                message: "Create your first CV to get started",
                buttonTitle: "Create CV"
            ) {
                print("Create tapped")
            }
        }
        .padding()
    }
    .background(AppColors.background)
}
