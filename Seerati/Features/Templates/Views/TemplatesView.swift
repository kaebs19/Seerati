//
//  TemplatesView.swift
//  Seerati
//
//  Path: Seerati/Features/Templates/Views/TemplatesView.swift
//
//  ─────────────────────────────────────────────────
//  AR: شاشة القوالب
//  EN: Templates Screen
//  ─────────────────────────────────────────────────

import SwiftUI

// MARK: - Templates View Strings
private enum TemplatesViewStrings {
    static var title: String {
        LocalizationManager.shared.isArabic ? "القوالب" : "Templates"
    }
    
    static var done: String {
        LocalizationManager.shared.isArabic ? "تم" : "Done"
    }
    
    static var premium: String {
        LocalizationManager.shared.isArabic ? "مميز" : "Premium"
    }
    
    static var previewTemplate: String {
        LocalizationManager.shared.isArabic ? "معاينة القالب" : "Preview Template"
    }
    
    static var useTemplate: String {
        LocalizationManager.shared.isArabic ? "استخدام هذا القالب" : "Use This Template"
    }
    
    static var upgradeToUse: String {
        LocalizationManager.shared.isArabic ? "ترقية لاستخدام القالب" : "Upgrade to Use"
    }
    
    static var premiumFeature: String {
        LocalizationManager.shared.isArabic ? "ميزة مدفوعة" : "Premium Feature"
    }
    
    static var premiumMessage: String {
        LocalizationManager.shared.isArabic ? "هذا القالب متاح للمستخدمين المميزين فقط." : "This template is for premium users only."
    }
    
    static var upgrade: String {
        LocalizationManager.shared.isArabic ? "ترقية" : "Upgrade"
    }
    
    static var cancel: String {
        LocalizationManager.shared.isArabic ? "إلغاء" : "Cancel"
    }
    
    static var new: String {
        LocalizationManager.shared.isArabic ? "جديد" : "New"
    }
}

// MARK: - Templates View
struct TemplatesView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: TemplateCategory = .all
    @State private var selectedTemplate: Template?
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Tabs
                categoryTabs
                
                // Templates Grid
                templatesGrid
            }
            .background(AppColors.background)
            .navigationTitle(TemplatesViewStrings.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(TemplatesViewStrings.done) {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedTemplate) { template in
                TemplatePreviewSheet(template: template)
            }
        }
    }
    
    // MARK: - Category Tabs
    private var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(TemplateCategory.allCases) { category in
                    TemplateCategoryTab(
                        title: category.localizedName,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.vertical, AppSpacing.md)
        }
        .background(AppColors.surface)
    }
    
    // MARK: - Templates Grid
    private var templatesGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: AppSpacing.md),
                    GridItem(.flexible(), spacing: AppSpacing.md)
                ],
                spacing: AppSpacing.md
            ) {
                ForEach(filteredTemplates) { template in
                    TemplateCardView(template: template) {
                        selectedTemplate = template
                    }
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.vertical, AppSpacing.md)
        }
    }
    
    // MARK: - Filtered Templates
    private var filteredTemplates: [Template] {
        Template.filter(by: selectedCategory)
    }
}

// MARK: - Category Tab
struct TemplateCategoryTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.subheadline(weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.primary : AppColors.background)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Template Card View
struct TemplateCardView: View {
    let template: Template
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm) {
                // Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(template.primaryColor.opacity(0.1))
                        .frame(height: 160)
                    
                    // Template Preview
                    VStack(spacing: AppSpacing.sm) {
                        // Placeholder CV preview
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(template.primaryColor.opacity(0.4))
                                .frame(width: 50, height: 8)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(template.primaryColor.opacity(0.25))
                                .frame(width: 70, height: 5)
                            
                            Spacer().frame(height: 8)
                            
                            // Content lines
                            ForEach(0..<4, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(template.primaryColor.opacity(0.15))
                                    .frame(width: 80, height: 3)
                            }
                        }
                    }
                    
                    // Badges
                    VStack {
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                // Premium Badge
                                if template.isPremium {
                                    Text(TemplatesViewStrings.premium)
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(Color.orange)
                                        .clipShape(Capsule())
                                }
                                
                                // New Badge
                                if template.isNew {
                                    Text(TemplatesViewStrings.new)
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(Color.green)
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(6)
                        }
                        Spacer()
                    }
                }
                
                // Name
                VStack(spacing: 2) {
                    Text(template.localizedName)
                        .font(AppFonts.subheadline(weight: .medium))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(template.localizedDescription)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .padding(AppSpacing.sm)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Template Preview Sheet
struct TemplatePreviewSheet: View {
    let template: Template
    @Environment(\.dismiss) private var dismiss
    @State private var showPremiumAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                // Large Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(template.primaryColor.opacity(0.1))
                        .frame(height: 400)
                    
                    // Template Preview
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(template.primaryColor.opacity(0.5))
                                .frame(width: 100, height: 14)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(template.primaryColor.opacity(0.3))
                                .frame(width: 80, height: 8)
                        }
                        
                        // Content
                        VStack(spacing: 20) {
                            ForEach(0..<3, id: \.self) { _ in
                                VStack(alignment: .leading, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(template.primaryColor.opacity(0.4))
                                        .frame(width: 60, height: 8)
                                    
                                    VStack(spacing: 4) {
                                        ForEach(0..<3, id: \.self) { _ in
                                            RoundedRectangle(cornerRadius: 1)
                                                .fill(template.primaryColor.opacity(0.15))
                                                .frame(width: 150, height: 4)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Template Name
                        Text(template.localizedName)
                            .font(AppFonts.title3(weight: .semibold))
                            .foregroundStyle(AppColors.textPrimary)
                        
                        Text(template.localizedDescription)
                            .font(AppFonts.body())
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    
                    // Premium Badge
                    if template.isPremium {
                        VStack {
                            HStack {
                                Spacer()
                                HStack(spacing: 4) {
                                    Image(systemName: "crown.fill")
                                    Text(TemplatesViewStrings.premium)
                                }
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange)
                                .clipShape(Capsule())
                                .padding()
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                
                Spacer()
                
                // Use Button
                Button {
                    if template.isPremium {
                        showPremiumAlert = true
                    } else {
                        UserDefaults.standard.set(template.id, forKey: "selectedTemplateId")
                        dismiss()
                    }
                } label: {
                    HStack {
                        if template.isPremium {
                            Image(systemName: "crown.fill")
                        }
                        Text(template.isPremium ? TemplatesViewStrings.upgradeToUse : TemplatesViewStrings.useTemplate)
                    }
                    .font(AppFonts.body(weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(template.isPremium ? Color.orange : AppColors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.bottom, AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle(TemplatesViewStrings.previewTemplate)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
            .alert(TemplatesViewStrings.premiumFeature, isPresented: $showPremiumAlert) {
                Button(TemplatesViewStrings.cancel, role: .cancel) { }
                Button(TemplatesViewStrings.upgrade) {
                    // Show paywall
                }
            } message: {
                Text(TemplatesViewStrings.premiumMessage)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    TemplatesView()
}
