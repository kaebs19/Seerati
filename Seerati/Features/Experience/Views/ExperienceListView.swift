//
//  ExperienceListView.swift
//  Seerati
//
//  Path: Seerati/Features/Experience/Views/ExperienceListView.swift
//
//  ─────────────────────────────────────────────
//  AR: شاشة عرض وإدارة الخبرات العملية
//  EN: Work experience list and management screen
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Experience List View
struct ExperienceListView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ExperienceViewModel
    @State private var showEducation = false
    @State private var showDeleteAlert = false
    @State private var experienceToDelete: Experience?
    
    // MARK: - Init
    init(cv: CVData) {
        _viewModel = State(initialValue: ExperienceViewModel(cv: cv))
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            // Content
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Title
                    titleSection
                    
                    // Experiences List or Empty State
                    if viewModel.hasExperiences {
                        experiencesList
                    } else {
                        emptyState
                    }
                    
                    // Add Button
                    addButton
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.lg)
            }
            
            // Bottom
            bottomSection
        }
        .background(AppColors.background)
        .navigationTitle(ExperienceStrings.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(AppColors.textPrimary)
                }
            }
        }
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .sheet(isPresented: $viewModel.showAddSheet) {
            AddExperienceSheet(experience: viewModel.experienceToEdit) { experience in
                if viewModel.experienceToEdit == nil {
                    viewModel.addExperience(experience)
                } else {
                    viewModel.saveChanges()
                }
                viewModel.experienceToEdit = nil
            }
        }
        .alert("Delete Experience?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                experienceToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let exp = experienceToDelete {
                    viewModel.deleteExperience(exp)
                }
                experienceToDelete = nil
            }
        } message: {
            Text("This action cannot be undone.")
        }
        .navigationDestination(isPresented: $showEducation) {
            EducationListView(cv: viewModel.cv)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                Text("STEP 2 OF 4")
                    .font(AppFonts.caption(weight: .semibold))
                    .foregroundStyle(AppColors.primary)
                
                Spacer()
                
                Text(ExperienceStrings.title)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            StepIndicator(totalSteps: 4, currentStep: 2)
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.vertical, AppSpacing.md)
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(ExperienceStrings.shareExperience)
                .font(AppFonts.title())
                .foregroundStyle(AppColors.textPrimary)
            
            Text(ExperienceStrings.experienceDescription)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Experiences List
    private var experiencesList: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(viewModel.experiences) { experience in
                ExperienceCard(
                    experience: experience,
                    onEdit: {
                        viewModel.editExperience(experience)
                    },
                    onDelete: {
                        experienceToDelete = experience
                        showDeleteAlert = true
                    }
                )
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "briefcase")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.textSecondary)
            
            Text(ExperienceStrings.noExperience)
                .font(AppFonts.title3())
                .foregroundStyle(AppColors.textPrimary)
            
            Text(ExperienceStrings.addFirstExperience)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xxl)
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            viewModel.experienceToEdit = nil
            viewModel.showAddSheet = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text(ExperienceStrings.addExperience)
            }
            .font(AppFonts.body(weight: .medium))
            .foregroundStyle(AppColors.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.primary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
        }
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        HStack(spacing: AppSpacing.md) {
            // Skip Button
            Button {
                showEducation = true
            } label: {
                Text(ExperienceStrings.skip)
                    .font(AppFonts.button())
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            // Continue Button
            PrimaryButton(
                ExperienceStrings.continueToEducation,
                icon: "arrow.right"
            ) {
                showEducation = true
            }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.vertical, AppSpacing.lg)
        .background(AppColors.background)
    }
}


// MARK: - Preview
#Preview {
    NavigationStack {
        ExperienceListView(cv: CVData.preview)
    }
}
