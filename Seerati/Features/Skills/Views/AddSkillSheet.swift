//
//  AddSkillSheet.swift
//  Seerati
//
//  Path: Seerati/Features/Skills/Views/AddSkillSheet.swift
//
//  ─────────────────────────────────────────────
//  AR: نموذج إضافة/تعديل المهارة
//  EN: Add/Edit skill form sheet
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Add Skill Sheet
struct AddSkillSheet: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: AddSkillViewModel
    
    var onSave: (Skill) -> Void
    
    // MARK: - Init
    init(skill: Skill? = nil, onSave: @escaping (Skill) -> Void) {
        self._viewModel = State(initialValue: AddSkillViewModel(skill: skill))
        self.onSave = onSave
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Skill Name
                    InputField(
                        label: SkillsStrings.skillName,
                        placeholder: SkillsStrings.skillNamePlaceholder,
                        icon: "star.fill",
                        text: $viewModel.name
                    )
                    
                    // Category Picker
                    categorySection
                    
                    // Level Picker
                    levelSection
                    
                    // Suggestions (only for new skill)
                    if !viewModel.isEditing {
                        suggestionsSection
                    }
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle(viewModel.isEditing ? SkillsStrings.editSkill : SkillsStrings.addSkill)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(SkillsStrings.save) {
                        let skill = viewModel.createOrUpdateSkill()
                        onSave(skill)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(viewModel.isValid ? AppColors.primary : AppColors.textSecondary)
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
    
    // MARK: - Category Section
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(SkillsStrings.category)
                .font(AppFonts.caption(weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)
            
            // Category Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(SkillCategory.allCases, id: \.rawValue) { category in
                        CategoryPill(
                            category: category,
                            isSelected: viewModel.category == category
                        ) {
                            viewModel.category = category
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Level Section
    private var levelSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text(SkillsStrings.proficiencyLevel)
                    .font(AppFonts.caption(weight: .semibold))
                    .foregroundStyle(AppColors.textSecondary)
                
                Spacer()
                
                Text(currentLevelText)
                    .font(AppFonts.body(weight: .medium))
                    .foregroundStyle(AppColors.primary)
            }
            
            // Level Slider
            VStack(spacing: AppSpacing.xs) {
                Slider(value: Binding(
                    get: { Double(viewModel.level) },
                    set: { viewModel.level = Int($0) }
                ), in: 1...5, step: 1)
                .tint(AppColors.primary)
                
                // Level Labels
                HStack {
                    ForEach(SkillLevel.allCases, id: \.rawValue) { level in
                        Text("\(level.rawValue)")
                            .font(AppFonts.caption2())
                            .foregroundStyle(viewModel.level == level.rawValue ? AppColors.primary : AppColors.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        }
    }
    
    // MARK: - Suggestions Section
    private var suggestionsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(SkillsStrings.suggestions)
                .font(AppFonts.caption(weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)
            
            // Show suggestions based on category
            FlowLayout(spacing: AppSpacing.xs) {
                ForEach(currentSuggestions, id: \.self) { suggestion in
                    SkillSuggestionChip(
                        name: suggestion,
                        isSelected: viewModel.name == suggestion
                    ) {
                        viewModel.name = suggestion
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    private var currentLevelText: String {
        let level = SkillLevel(rawValue: viewModel.level) ?? .intermediate
        return LocalizationManager.shared.isArabic ? level.arabicName : level.name
    }
    
    private var currentSuggestions: [String] {
        switch viewModel.category {
        case .technical: return SkillSuggestions.technical
        case .soft: return SkillSuggestions.soft
        case .tools: return SkillSuggestions.tools
        case .language: return SkillSuggestions.languages
        case .other: return []
        }
    }
}

// MARK: - Category Pill
struct CategoryPill: View {
    let category: SkillCategory
    var isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: categoryIcon)
                    .font(.system(size: 12))
                
                Text(categoryName)
                    .font(AppFonts.caption(weight: .medium))
            }
            .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? AppColors.primary : AppColors.surface)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : AppColors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var categoryName: String {
        LocalizationManager.shared.isArabic ? category.arabicName : category.rawValue
    }
    
    private var categoryIcon: String {
        switch category {
        case .technical: return "laptopcomputer"
        case .soft: return "person.2.fill"
        case .language: return "globe"
        case .tools: return "wrench.fill"
        case .other: return "star.fill"
        }
    }
}

// MARK: - Preview
#Preview {
    AddSkillSheet { skill in
        print("Saved: \(skill.name)")
    }
}
