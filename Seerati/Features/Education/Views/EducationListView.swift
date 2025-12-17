//
//  EducationListView.swift
//  Seerati
//
//  Path: Seerati/Features/Education/Views/EducationListView.swift
//
//  ─────────────────────────────────────────────
//  AR: شاشة قائمة التعليم - الخطوة 3 من إنشاء السيرة
//  EN: Education list screen - Step 3 of CV creation
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Education List View
struct EducationListView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: EducationViewModel
    @State private var showDeleteConfirmation = false
    @State private var educationToDelete: Education?
    
    // Navigation
    @State private var navigateToSkills = false
    
    // MARK: - Init
    init(cv: CVData) {
        self._viewModel = State(initialValue: EducationViewModel(cv: cv))
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    // Header
                    headerSection
                    
                    // Education List or Empty State
                    if viewModel.hasEducations {
                        educationsList
                    } else {
                        emptyState
                    }
                    
                    // Add Button
                    addButton
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.lg)
            }
            
            // Bottom Buttons
            bottomButtons
        }
        .background(AppColors.background)
        .navigationTitle(EducationStrings.title)
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
                StepIndicator(totalSteps: 4, currentStep: 3)
            }
        }
        .sheet(isPresented: $viewModel.showAddSheet) {
            AddEducationSheet(education: viewModel.educationToEdit) { education in
                if viewModel.educationToEdit != nil {
                    viewModel.saveChanges()
                } else {
                    viewModel.addEducation(education)
                }
                viewModel.educationToEdit = nil
            }
        }
        .alert("Delete Education?", isPresented: $showDeleteConfirmation, presenting: educationToDelete) { education in
            Button("Cancel", role: .cancel) {
                educationToDelete = nil
            }
            Button("Delete", role: .destructive) {
                viewModel.deleteEducation(education)
                educationToDelete = nil
            }
        } message: { _ in
            Text("This action cannot be undone.")
        }
        .navigationDestination(isPresented: $navigateToSkills) {
            SkillsListView(cv: viewModel.cv)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(EducationStrings.shareEducation)
                .font(AppFonts.title3())
                .foregroundStyle(AppColors.textPrimary)
            
            Text(EducationStrings.educationDescription)
                .font(AppFonts.subheadline())
                .foregroundStyle(AppColors.textSecondary)
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "graduationcap")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            
            Text(EducationStrings.noEducation)
                .font(AppFonts.body(weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
            
            Text(EducationStrings.addFirstEducation)
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xxl)
    }
    
    // MARK: - Educations List
    private var educationsList: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(viewModel.educations, id: \.id) { education in
                EducationCard(
                    education: education,
                    onEdit: {
                        viewModel.editEducation(education)
                    },
                    onDelete: {
                        educationToDelete = education
                        showDeleteConfirmation = true
                    }
                )
            }
        }
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            viewModel.educationToEdit = nil
            viewModel.showAddSheet = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text(EducationStrings.addEducation)
            }
            .font(AppFonts.body(weight: .medium))
            .foregroundStyle(AppColors.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.primary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
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
                    navigateToSkills = true
                } label: {
                    Text(EducationStrings.skip)
                        .font(AppFonts.button())
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
                }
                
                // Continue Button
                Button {
                    navigateToSkills = true
                } label: {
                    Text(EducationStrings.continueToSkills)
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
}

// MARK: - Preview
#Preview {
    NavigationStack {
        EducationListView(cv: CVData(cvName: "Test CV"))
    }
}
