//
//  AdditionalPersonalInfoView.swift
//  Seerati
//
//  Path: Seerati/Features/CVBuilder/Views/AdditionalPersonalInfoView.swift
//
//  ─────────────────────────────────────────────────
//  AR: شاشة المعلومات الشخصية الإضافية
//  EN: Additional Personal Information Screen
//  ─────────────────────────────────────────────────

import SwiftUI

// MARK: - Additional Personal Info View
struct AdditionalPersonalInfoView: View {
    
    // MARK: - Properties
    @Bindable var cv: CVData
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate: Date = Date()
    @State private var showDatePicker = false
    @State private var showNationalityPicker = false
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Header
                headerSection
                
                // Info Cards
                VStack(spacing: AppSpacing.md) {
                    // تاريخ الميلاد
                    dateOfBirthCard
                    
                    // الجنسية
                    nationalityCard
                    
                    // الجنس
                    genderCard
                    
                    // الحالة الاجتماعية
                    maritalStatusCard
                    
                    // رخصة القيادة
                    drivingLicenseCard
                    
                    // حالة الإقامة
                    visaStatusCard
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                
                // Note
                noteSection
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                
                Spacer(minLength: 100)
            }
            .padding(.top, AppSpacing.md)
        }
        .background(AppColors.background)
        .navigationTitle("المعلومات الشخصية")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showNationalityPicker) {
            NationalityPickerSheet(selectedNationality: $cv.nationality)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "person.text.rectangle.fill")
                .font(.system(size: 50))
                .foregroundStyle(AppColors.primary)
            
            Text("معلومات إضافية")
                .font(AppFonts.title3(weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
            
            Text("هذه المعلومات اختيارية، يمكنك اختيار إظهارها أو إخفائها في السيرة")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
        }
        .padding(.bottom, AppSpacing.md)
    }
    
    // MARK: - Date of Birth Card
    private var dateOfBirthCard: some View {
        InfoFieldCard(
            title: "تاريخ الميلاد",
            icon: "calendar",
            isEnabled: $cv.showDateOfBirth
        ) {
            Button {
                showDatePicker = true
            } label: {
                HStack {
                    Text(cv.dateOfBirth != nil ? cv.formattedDateOfBirth : "اختر التاريخ")
                        .font(AppFonts.body())
                        .foregroundStyle(cv.dateOfBirth != nil ? AppColors.textPrimary : AppColors.textSecondary)
                    
                    Spacer()
                    
                    if let age = cv.age {
                        Text("(\(age) سنة)")
                            .font(AppFonts.caption())
                            .foregroundStyle(AppColors.primary)
                    }
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerSheet(selectedDate: Binding(
                    get: { cv.dateOfBirth ?? Date() },
                    set: { cv.dateOfBirth = $0 }
                ))
            }
        }
    }
    
    // MARK: - Nationality Card
    private var nationalityCard: some View {
        InfoFieldCard(
            title: "الجنسية",
            icon: "globe",
            isEnabled: $cv.showNationality
        ) {
            Button {
                showNationalityPicker = true
            } label: {
                HStack {
                    Text(cv.nationality.isEmpty ? "اختر الجنسية" : cv.nationality)
                        .font(AppFonts.body())
                        .foregroundStyle(cv.nationality.isEmpty ? AppColors.textSecondary : AppColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Gender Card
    private var genderCard: some View {
        InfoFieldCard(
            title: "الجنس",
            icon: "person.fill",
            isEnabled: $cv.showGender
        ) {
            HStack(spacing: AppSpacing.sm) {
                ForEach([Gender.male, Gender.female], id: \.self) { gender in
                    SelectableChip(
                        title: gender.localizedName,
                        isSelected: cv.gender == gender
                    ) {
                        cv.gender = gender
                    }
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Marital Status Card
    private var maritalStatusCard: some View {
        InfoFieldCard(
            title: "الحالة الاجتماعية",
            icon: "heart.fill",
            isEnabled: $cv.showMaritalStatus
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.xs) {
                    ForEach([MaritalStatus.single, .married, .divorced, .widowed], id: \.self) { status in
                        SelectableChip(
                            title: status.localizedName,
                            isSelected: cv.maritalStatus == status
                        ) {
                            cv.maritalStatus = status
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Driving License Card
    private var drivingLicenseCard: some View {
        InfoFieldCard(
            title: "رخصة القيادة",
            icon: "car.fill",
            isEnabled: $cv.showDrivingLicense
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.xs) {
                    ForEach([DrivingLicense.none, .car, .motorcycle, .international], id: \.self) { license in
                        SelectableChip(
                            title: license.localizedName,
                            isSelected: cv.drivingLicense == license
                        ) {
                            cv.drivingLicense = license
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Visa Status Card
    private var visaStatusCard: some View {
        InfoFieldCard(
            title: "حالة الإقامة",
            icon: "doc.text.fill",
            isEnabled: $cv.showVisaStatus
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.xs) {
                    ForEach([VisaStatus.citizen, .resident, .transferable, .needsSponsorship], id: \.self) { status in
                        SelectableChip(
                            title: status.localizedName,
                            isSelected: cv.visaStatus == status
                        ) {
                            cv.visaStatus = status
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Note Section
    private var noteSection: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "lightbulb.fill")
                .foregroundStyle(AppColors.warning)
            
            Text("استخدم زر التفعيل لإظهار أو إخفاء المعلومة في السيرة الذاتية")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
            
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.warning.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Info Field Card
struct InfoFieldCard<Content: View>: View {
    let title: String
    let icon: String
    @Binding var isEnabled: Bool
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Header
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(AppColors.primary)
                
                Text(title)
                    .font(AppFonts.caption(weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                
                Spacer()
                
                // Toggle
                Toggle("", isOn: $isEnabled)
                    .labelsHidden()
                    .tint(AppColors.primary)
                    .scaleEffect(0.8)
            }
            
            // Content
            content()
                .opacity(isEnabled ? 1 : 0.5)
                .disabled(!isEnabled)
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Selectable Chip
struct SelectableChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.caption(weight: .medium))
                .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.primary : AppColors.background)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : AppColors.border, lineWidth: 1)
                )
        }
    }
}

// MARK: - Date Picker Sheet
struct DatePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "تاريخ الميلاد",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ar"))
                
                Spacer()
            }
            .padding()
            .navigationTitle("تاريخ الميلاد")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("تم") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Nationality Picker Sheet
struct NationalityPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedNationality: String
    @State private var searchText = ""
    
    var filteredNationalities: [CommonNationality] {
        if searchText.isEmpty {
            return CommonNationality.allCases
        }
        return CommonNationality.allCases.filter {
            $0.localizedName.contains(searchText) || $0.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredNationalities, id: \.self) { nationality in
                    Button {
                        selectedNationality = nationality.localizedName
                        dismiss()
                    } label: {
                        HStack {
                            Text(nationality.localizedName)
                                .foregroundStyle(AppColors.textPrimary)
                            
                            Spacer()
                            
                            if selectedNationality == nationality.localizedName {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppColors.primary)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "ابحث عن جنسية")
            .navigationTitle("الجنسية")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("إلغاء") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AdditionalPersonalInfoView(cv: CVData.preview)
    }
}
