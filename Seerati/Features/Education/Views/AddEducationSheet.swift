//
//  AddEducationSheet.swift
//  Seerati
//
//  Path: Seerati/Features/Education/Views/AddEducationSheet.swift
//
//  ─────────────────────────────────────────────
//  AR: نموذج إضافة/تعديل التعليم
//  EN: Add/Edit education form sheet
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Add Education Sheet
struct AddEducationSheet: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: AddEducationViewModel
    
    var onSave: (Education) -> Void
    
    // MARK: - Init
    init(education: Education? = nil, onSave: @escaping (Education) -> Void) {
        self._viewModel = State(initialValue: AddEducationViewModel(education: education))
        self.onSave = onSave
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.inputSpacing) {
                    // Degree
                    InputField(
                        label: EducationStrings.degree,
                        placeholder: EducationStrings.degreePlaceholder,
                        icon: "graduationcap.fill",
                        text: $viewModel.degree
                    )
                    
                    // Field of Study
                    InputField(
                        label: EducationStrings.fieldOfStudy,
                        placeholder: EducationStrings.fieldOfStudyPlaceholder,
                        icon: "book.fill",
                        text: $viewModel.fieldOfStudy
                    )
                    
                    // Institution
                    InputField(
                        label: EducationStrings.institution,
                        placeholder: EducationStrings.institutionPlaceholder,
                        icon: "building.columns.fill",
                        text: $viewModel.institution
                    )
                    
                    // Location
                    InputField(
                        label: EducationStrings.location,
                        placeholder: EducationStrings.locationPlaceholder,
                        icon: "location.fill",
                        text: $viewModel.location
                    )
                    
                    // Dates Section
                    datesSection
                    
                    // GPA
                    InputField(
                        label: EducationStrings.gpa,
                        placeholder: EducationStrings.gpaPlaceholder,
                        icon: "star.fill",
                        text: $viewModel.gpa
                    )
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle(viewModel.isEditing ? EducationStrings.editEducation : EducationStrings.addEducation)
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
                    Button(EducationStrings.save) {
                        let education = viewModel.createOrUpdateEducation()
                        onSave(education)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(viewModel.isValid ? AppColors.primary : AppColors.textSecondary)
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
    
    // MARK: - Dates Section
    private var datesSection: some View {
        VStack(spacing: AppSpacing.md) {
            // Start Date
            DatePickerField(
                label: EducationStrings.startDate,
                date: $viewModel.startDate
            )
            
            // Currently Studying Toggle
            Toggle(isOn: $viewModel.isCurrentlyStudying) {
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundStyle(AppColors.textSecondary)
                    Text(EducationStrings.currentlyStudying)
                        .font(AppFonts.body())
                }
            }
            .tint(AppColors.primary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            
            // End Date
            if !viewModel.isCurrentlyStudying {
                DatePickerField(
                    label: EducationStrings.endDate,
                    date: $viewModel.endDate
                )
            }
        }
    }
}


// MARK: - Preview
#Preview {
    AddEducationSheet { education in
        print("Saved: \(education.degree)")
    }
}
