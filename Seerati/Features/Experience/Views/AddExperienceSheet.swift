//
//  AddExperienceSheet.swift
//  Seerati
//
//  Path: Seerati/Features/Experience/Views/AddExperienceSheet.swift
//
//  ─────────────────────────────────────────────
//  AR: نموذج إضافة أو تعديل الخبرة العملية
//  EN: Add or edit work experience form sheet
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Add Experience Sheet
struct AddExperienceSheet: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddExperienceViewModel
    var onSave: (Experience) -> Void
    
    // MARK: - Init
    init(experience: Experience? = nil, onSave: @escaping (Experience) -> Void) {
        _viewModel = State(initialValue: AddExperienceViewModel(experience: experience))
        self.onSave = onSave
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.inputSpacing) {
                    // Job Title
                    InputField(
                        label: ExperienceStrings.jobTitle,
                        placeholder: ExperienceStrings.jobTitlePlaceholder,
                        icon: "briefcase.fill",
                        text: $viewModel.jobTitle
                    )
                    
                    // Company
                    InputField(
                        label: ExperienceStrings.company,
                        placeholder: ExperienceStrings.companyPlaceholder,
                        icon: "building.2.fill",
                        text: $viewModel.company
                    )
                    
                    // Location
                    InputField(
                        label: ExperienceStrings.location,
                        placeholder: ExperienceStrings.locationPlaceholder,
                        icon: "location.fill",
                        text: $viewModel.location
                    )
                    
                    // Dates Section
                    datesSection
                    
                    // Description
                    InputField(
                        label: ExperienceStrings.description,
                        placeholder: ExperienceStrings.descriptionPlaceholder,
                        icon: nil,
                        text: $viewModel.jobDescription,
                        isMultiline: true
                    )
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle(viewModel.isEditing ? ExperienceStrings.editExperience : ExperienceStrings.addExperience)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(AppColors.textPrimary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(ExperienceStrings.save) {
                        let experience = viewModel.createOrUpdateExperience()
                        onSave(experience)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(viewModel.isValid ? AppColors.primary : AppColors.textSecondary)
                    .disabled(!viewModel.isValid)
                }
            }
            .toolbarBackground(AppColors.background, for: .navigationBar)
        }
    }
    
    // MARK: - Dates Section
    private var datesSection: some View {
        VStack(spacing: AppSpacing.md) {
            // Start Date
            DatePickerField(
                label: ExperienceStrings.startDate,
                date: $viewModel.startDate
            )
            
            // Currently Working Toggle
            Toggle(isOn: $viewModel.isCurrentJob) {
                Text(ExperienceStrings.currentlyWorking)
                    .font(AppFonts.body())
                    .foregroundStyle(AppColors.textPrimary)
            }
            .tint(AppColors.primary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            
            // End Date
            if !viewModel.isCurrentJob {
                DatePickerField(
                    label: ExperienceStrings.endDate,
                    date: $viewModel.endDate
                )
            }
        }
    }
}

// MARK: - Date Picker Field
struct DatePickerField: View {
    
    let label: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(label.uppercased())
                .font(AppFonts.inputLabel())
                .foregroundStyle(AppColors.textSecondary)
            
            DatePicker(
                "",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.inputBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            .tint(AppColors.primary)
        }
    }
}

// MARK: - Preview
#Preview {
    AddExperienceSheet { experience in
        print("Saved: \(experience.jobTitle)")
    }
}
