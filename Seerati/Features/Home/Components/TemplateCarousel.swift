//
//  TemplateCarousel.swift
//  Seerati
//
//  Path: Seerati/Features/Home/Components/TemplateCarousel.swift
//
//  ─────────────────────────────────────────────
//  AR: عرض أفقي لقوالب السيرة الذاتية
//  EN: Horizontal carousel for CV templates
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Template Carousel
struct TemplateCarousel: View {
    
    // MARK: - Properties
    let templates: [Template]
    var onSelect: (Template) -> Void
    
    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.md) {
                ForEach(templates) { template in
                    TemplateCarouselCard(
                        template: template,
                        onTap: { onSelect(template) }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
        }
    }
}

// MARK: - Template Carousel Card
struct TemplateCarouselCard: View {
    
    let template: Template
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Preview Image
                ZStack(alignment: .topLeading) {
                    // Placeholder Preview
                    RoundedRectangle(cornerRadius: AppSpacing.radiusMedium)
                        .fill(Color.white)
                        .frame(width: 140, height: 180)
                        .overlay(
                            TemplatePreviewPlaceholder(template: template)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
                    
                    // Badge
                    if template.isNew {
                        BadgeView(text: "New", color: AppColors.primary)
                            .padding(AppSpacing.xs)
                    } else if template.isPremium {
                        BadgeView(text: "Premium", color: AppColors.warning)
                            .padding(AppSpacing.xs)
                    }
                }
                
                // Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(template.localizedName)
                        .font(AppFonts.subheadline(weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text(template.localizedDescription)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Template Preview Placeholder
struct TemplatePreviewPlaceholder: View {
    
    let template: Template
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header
            RoundedRectangle(cornerRadius: 2)
                .fill(template.primaryColor)
                .frame(height: 24)
            
            // Lines
            ForEach(0..<5, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 6)
            }
            
            Spacer()
            
            // Skills
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 30, height: 10)
                }
            }
        }
        .padding(12)
    }
}

// MARK: - Badge View
struct BadgeView: View {
    
    let text: String
    var color: Color = AppColors.primary
    
    var body: some View {
        Text(text)
            .font(AppFonts.caption2(weight: .semibold))
            .foregroundStyle(color == AppColors.warning ? .black : .white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .clipShape(Capsule())
    }
}

// MARK: - Preview
#Preview {
    VStack(alignment: .leading, spacing: 16) {
        SectionHeader(title: HomeStrings.templates, actionTitle: HomeStrings.viewAll) {
            print("View all")
        }
        .padding(.horizontal)
        
        TemplateCarousel(templates: Template.allTemplates) { template in
            print("Selected: \(template.name)")
        }
    }
    .padding(.vertical)
    .background(AppColors.background)
}
