//
//  PersonalInfoView.swift
//  Seerati
//
//  Path: Seerati/Features/PersonalInfo/Views/PersonalInfoView.swift
//
//  ─────────────────────────────────────────────
//  AR: شاشة إدخال المعلومات الشخصية - الخطوة الثانية
//  EN: Personal information input screen - step two
//  ─────────────────────────────────────────────

import SwiftUI
import PhotosUI

// MARK: - Personal Info View
struct PersonalInfoMainView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PersonalInfoViewModel
    @State private var showExperience = false
    
    // MARK: - Init
    init(cv: CVData) {
        _viewModel = State(initialValue: PersonalInfoViewModel(cv: cv))
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Header with Progress
            headerSection
            
            // Content
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Title
                    titleSection
                    
                    // Photo
                    photoSection
                    
                    // Form Fields
                    formSection
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.lg)
            }
            
            // Bottom Button
            bottomSection
        }
        .background(AppColors.background)
        .navigationTitle(PersonalInfoStrings.title)
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
        .onChange(of: viewModel.selectedPhotoItem) { _, _ in
            Task {
                await viewModel.loadPhoto()
            }
        }
        .navigationDestination(isPresented: $showExperience) {
            ExperienceListMainView(cv: viewModel.cv)
        }
        .onChange(of: viewModel.isSaved) { _, isSaved in
            if isSaved {
                showExperience = true
            }
        }
        .onAppear {
            viewModel.autoFill()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                Text("STEP 1 OF 4")
                    .font(AppFonts.caption(weight: .semibold))
                    .foregroundStyle(AppColors.primary)
                
                Spacer()
                
                Text(PersonalInfoStrings.basicInfo)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            StepIndicator(totalSteps: 4, currentStep: 1)
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.vertical, AppSpacing.md)
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(PersonalInfoStrings.letsStart)
                .font(AppFonts.title())
                .foregroundStyle(AppColors.textPrimary)
            
            Text(PersonalInfoStrings.addContactDetails)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Photo Section
    private var photoSection: some View {
        PhotoPickerView(
            photoData: $viewModel.photoData,
            selectedItem: $viewModel.selectedPhotoItem,
            onRemove: {
                viewModel.removePhoto()
            }
        )
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: AppSpacing.inputSpacing) {
            // Full Name
            InputField(
                label: PersonalInfoStrings.fullName,
                placeholder: PersonalInfoStrings.fullNamePlaceholder,
                icon: "person.fill",
                text: $viewModel.fullName,
                textContentType: .name
            )
            
            // Professional Title
            InputField(
                label: PersonalInfoStrings.professionalTitle,
                placeholder: PersonalInfoStrings.professionalTitlePlaceholder,
                icon: "briefcase.fill",
                text: $viewModel.jobTitle,
                textContentType: .jobTitle
            )
            
            // Email
            InputField(
                label: PersonalInfoStrings.emailAddress,
                placeholder: PersonalInfoStrings.emailPlaceholder,
                icon: "envelope.fill",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                textContentType: .emailAddress
            )
            
            // Phone
            InputField(
                label: PersonalInfoStrings.phoneNumber,
                placeholder: PersonalInfoStrings.phonePlaceholder,
                icon: "phone.fill",
                text: $viewModel.phone,
                keyboardType: .phonePad,
                textContentType: .telephoneNumber
            )
            
            // Location
            InputField(
                label: PersonalInfoStrings.location,
                placeholder: PersonalInfoStrings.locationPlaceholder,
                icon: "location.fill",
                text: $viewModel.location,
                textContentType: .fullStreetAddress
            )
            
            // Website
            InputField(
                label: PersonalInfoStrings.website,
                placeholder: PersonalInfoStrings.websitePlaceholder,
                icon: "link",
                text: $viewModel.website,
                keyboardType: .URL,
                textContentType: .URL
            )
        }
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: AppSpacing.sm) {
            // Error Message
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.error)
            }
            
            // Continue Button
            PrimaryButton(
                PersonalInfoStrings.continueToExperience,
                icon: "arrow.right",
                isLoading: viewModel.isSaving,
                isDisabled: !viewModel.canProceed
            ) {
                viewModel.save()
            }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.vertical, AppSpacing.lg)
        .background(AppColors.background)
    }
}

// MARK: - Placeholder for next step
struct ExperienceListMainView: View {
    let cv: CVData
    var body: some View {
        Text("Experience List")
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        PersonalInfoMainView(cv: CVData.preview)
    }
}
