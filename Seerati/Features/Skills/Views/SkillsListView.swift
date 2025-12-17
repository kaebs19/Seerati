//
//  SkillsListView.swift
//  Seerati
//
//  Path: Seerati/Features/Skills/Views/SkillsListView.swift
//
//  ─────────────────────────────────────────────
//  AR: شاشة قائمة المهارات - الخطوة 4 من إنشاء السيرة
//  EN: Skills list screen - Step 4 of CV creation
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Skills List View
struct SkillsListView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: SkillsViewModel
    @State private var showDeleteConfirmation = false
    @State private var skillToDelete: Skill?
    
    // Navigation
    @State private var navigateToPreview = false
    @State private var showFinishAlert = false
    
    // MARK: - Init
    init(cv: CVData) {
        self._viewModel = State(initialValue: SkillsViewModel(cv: cv))
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    // Header
                    headerSection
                    
                    // Skills List or Empty State
                    if viewModel.hasSkills {
                        skillsList
                    } else {
                        emptyState
                    }
                    
                    // Add Button
                    addButton
                    
                    // Quick Add Section
                    if !viewModel.hasSkills {
                        quickAddSection
                    }
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.lg)
            }
            
            // Bottom Buttons
            bottomButtons
        }
        .background(AppColors.background)
        .navigationTitle(SkillsStrings.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(AppColors.textPrimary)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                StepIndicator(totalSteps: 4, currentStep: 4)
            }
        }
        .sheet(isPresented: $viewModel.showAddSheet) {
            AddSkillSheet(skill: viewModel.skillToEdit) { skill in
                if viewModel.skillToEdit != nil {
                    viewModel.saveChanges()
                } else {
                    viewModel.addSkill(skill)
                }
                viewModel.skillToEdit = nil
            }
        }
        .alert("Delete Skill?", isPresented: $showDeleteConfirmation, presenting: skillToDelete) { skill in
            Button("Cancel", role: .cancel) {
                skillToDelete = nil
            }
            Button("Delete", role: .destructive) {
                viewModel.deleteSkill(skill)
                skillToDelete = nil
            }
        } message: { _ in
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $navigateToPreview) {
            CVPreviewView(cv: viewModel.cv)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(SkillsStrings.highlightSkills)
                .font(AppFonts.title3())
                .foregroundStyle(AppColors.textPrimary)
            
            Text(SkillsStrings.skillsDescription)
                .font(AppFonts.subheadline())
                .foregroundStyle(AppColors.textSecondary)
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "star.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            
            Text(SkillsStrings.noSkills)
                .font(AppFonts.body(weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
            
            Text(SkillsStrings.addFirstSkill)
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xxl)
    }
    
    // MARK: - Skills List
    private var skillsList: some View {
        VStack(spacing: AppSpacing.lg) {
            // Technical Skills
            SkillsSectionView(
                title: SkillsStrings.technicalSkills,
                icon: "laptopcomputer",
                skills: viewModel.technicalSkills,
                onEdit: { viewModel.editSkill($0) },
                onDelete: { confirmDelete($0) }
            )
            
            // Soft Skills
            SkillsSectionView(
                title: SkillsStrings.softSkills,
                icon: "person.2.fill",
                skills: viewModel.softSkills,
                onEdit: { viewModel.editSkill($0) },
                onDelete: { confirmDelete($0) }
            )
            
            // Tools
            SkillsSectionView(
                title: "Tools",
                icon: "wrench.fill",
                skills: viewModel.toolsSkills,
                onEdit: { viewModel.editSkill($0) },
                onDelete: { confirmDelete($0) }
            )
            
            // Languages
            SkillsSectionView(
                title: SkillsStrings.languageSkills,
                icon: "globe",
                skills: viewModel.languageSkills,
                onEdit: { viewModel.editSkill($0) },
                onDelete: { confirmDelete($0) }
            )
            
            // Other
            SkillsSectionView(
                title: SkillsStrings.otherSkills,
                icon: "star.fill",
                skills: viewModel.otherSkills,
                onEdit: { viewModel.editSkill($0) },
                onDelete: { confirmDelete($0) }
            )
        }
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            viewModel.skillToEdit = nil
            viewModel.showAddSheet = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text(SkillsStrings.addSkill)
            }
            .font(AppFonts.body(weight: .medium))
            .foregroundStyle(AppColors.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.primary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        }
    }
    
    // MARK: - Quick Add Section
    private var quickAddSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(SkillsStrings.popularSkills)
                .font(AppFonts.caption(weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)
            
            FlowLayout(spacing: AppSpacing.xs) {
                ForEach(quickSkills, id: \.name) { skill in
                    SkillSuggestionChip(name: skill.name) {
                        viewModel.addQuickSkill(
                            name: skill.name,
                            category: skill.category
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Bottom Buttons
    private var bottomButtons: some View {
        VStack(spacing: AppSpacing.sm) {
            Divider()
                .background(AppColors.border)
            
            HStack(spacing: AppSpacing.md) {
                // Skip Button
                Button {
                    navigateToHome()
                } label: {
                    Text(SkillsStrings.skip)
                        .font(AppFonts.button())
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
                }
                
                // Preview Button
                Button {
                    navigateToPreview = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "eye.fill")
                        Text(SkillsStrings.previewCV)
                    }
                    .font(AppFonts.button())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.bottom, AppSpacing.lg)
        }
        .background(AppColors.background)
    }
    
    // MARK: - Helpers
    private func confirmDelete(_ skill: Skill) {
        skillToDelete = skill
        showDeleteConfirmation = true
    }
    
    private func navigateToHome() {
        // Dismiss all sheets and navigate to root
        // This will be handled by the navigation stack
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.dismiss(animated: true)
        }
    }
    
    // Quick skills for suggestions
    private var quickSkills: [(name: String, category: SkillCategory)] {
        [
            ("Swift", .technical),
            ("Python", .technical),
            ("Communication", .soft),
            ("Leadership", .soft),
            ("Git", .tools),
            ("English", .language)
        ]
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SkillsListView(cv: CVData(cvName: "Test CV"))
    }
}
