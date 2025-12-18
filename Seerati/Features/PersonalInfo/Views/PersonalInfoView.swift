//
//  PersonalInfoView.swift
//  Seerati
//
//  Path: Seerati/Features/PersonalInfo/Views/PersonalInfoView.swift
//
//  ─────────────────────────────────────────────
//  AR: شاشة إدخال المعلومات الشخصية - الخطوة الأولى
//  EN: Personal information input screen - step one
//  ─────────────────────────────────────────────

import SwiftUI
import PhotosUI

// MARK: - Type Alias for compatibility
typealias PersonalInfoView = PersonalInfoMainView

// MARK: - Personal Info View
struct PersonalInfoMainView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PersonalInfoViewModel
    @State private var showExperience = false
    @State private var showAdditionalInfo = false

    
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
        // ✅ FIX: Use actual ExperienceListView
        .navigationDestination(isPresented: $showExperience) {
            ExperienceListView(cv: viewModel.cv)
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
    
    // MARK: - Photo Section
    private var photoSection: some View {
        VStack(spacing: AppSpacing.sm) {
            // Photo Circle
            ZStack {
                if let data = viewModel.photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(AppColors.surface)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(AppColors.textSecondary)
                        )
                }
            }
            
            // Photo Picker Button
            PhotosPicker(
                selection: $viewModel.selectedPhotoItem,
                matching: .images
            ) {
                Text(viewModel.photoData != nil ? PersonalInfoStrings.changePhoto : PersonalInfoStrings.uploadPhoto)
                    .font(AppFonts.subheadline(weight: .medium))
                    .foregroundStyle(AppColors.primary)
            }
        }
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
            
            // Website/LinkedIn
            InputField(
                label: PersonalInfoStrings.website,
                placeholder: PersonalInfoStrings.websitePlaceholder,
                icon: "link",
                text: $viewModel.website,
                keyboardType: .URL,
                textContentType: .URL
            )
            
            // ✅ رابط المعلومات الإضافية
            additionalInfoLink
        }
    }

    private var additionalInfoLink: some View {
        Button {
            showAdditionalInfo = true
        } label: {
            HStack {
                Image(systemName: "person.text.rectangle.fill")
                    .foregroundStyle(AppColors.primary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("معلومات إضافية")
                        .font(AppFonts.body(weight: .medium))
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text("تاريخ الميلاد، الجنسية، الحالة الاجتماعية...")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.left")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding()
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sheet(isPresented: $showAdditionalInfo) {
            NavigationStack {
                AdditionalPersonalInfoView(cv: viewModel.cv)
            }
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

// MARK: - Preview
#Preview {
    NavigationStack {
        PersonalInfoMainView(cv: CVData.preview)
    }
}
