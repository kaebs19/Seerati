//
//  CreateCVView.swift
//  Seerati
//
//  Path: Seerati/Features/CreateCV/Views/CreateCVView.swift
//
//  ─────────────────────────────────────────────
//  AR: شاشة إنشاء سيرة ذاتية جديدة - الخطوة الأولى
//  EN: Create new CV screen - first step
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Create CV View
struct CreateCVFlowView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CreateCVViewModel()
    @State private var showPersonalInfo = false
    @FocusState private var isNameFocused: Bool
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Indicator
                StepIndicator(totalSteps: 3, currentStep: 1)
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                    .padding(.top, AppSpacing.md)
                
                ScrollView {
                    VStack(spacing: AppSpacing.xxl) {
                        // Icon
                        cvIconSection
                        
                        // Title
                        titleSection
                        
                        // Input
                        inputSection
                    }
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                    .padding(.top, AppSpacing.xxl)
                }
                
                // Bottom Button
                bottomButton
            }
            .background(AppColors.background)
            .navigationTitle(CreateCVStrings.newCV)
            .navigationBarTitleDisplayMode(.inline)
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
                    Button(CreateCVStrings.cancel) {
                        dismiss()
                    }
                    .foregroundStyle(AppColors.textPrimary)
                }
            }
            .toolbarBackground(AppColors.background, for: .navigationBar)
        }
        .navigationDestination(isPresented: $showPersonalInfo) {
                   if let cv = viewModel.createdCV {
                       PersonalInfoMainView(cv: cv)
                   }
               }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isNameFocused = true
            }
        }
        .onChange(of: viewModel.isCreated) { _, isCreated in
            if isCreated {
                showPersonalInfo = true
            }
        }
    }
    
    // MARK: - CV Icon Section
    private var cvIconSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.surface)
                .frame(width: 120, height: 120)
            
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.primary)
        }
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Text(CreateCVStrings.whatShouldWeCall)
                .font(AppFonts.title())
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(CreateCVStrings.justForReference)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Input Section
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(CreateCVStrings.cvName)
                .font(AppFonts.inputLabel())
                .foregroundStyle(AppColors.textSecondary)
            
            TextField(CreateCVStrings.cvNamePlaceholder, text: $viewModel.cvName)
                .font(AppFonts.inputText())
                .foregroundStyle(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.md)
                .frame(height: AppSpacing.inputHeight)
                .background(AppColors.inputBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
                .focused($isNameFocused)
            
            // Validation Message
            if let message = viewModel.validationMessage {
                Text(message)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.error)
            }
        }
    }
    
    // MARK: - Bottom Button
    private var bottomButton: some View {
        VStack {
            PrimaryButton(
                CreateCVStrings.createAndContinue,
                icon: "arrow.right",
                isLoading: viewModel.isLoading,
                isDisabled: !viewModel.canProceed
            ) {
                viewModel.createCV()
            }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.vertical, AppSpacing.lg)
        .background(AppColors.background)
    }
}


// MARK: - Preview
#Preview {
    CreateCVFlowView()
}
