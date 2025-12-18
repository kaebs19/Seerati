//
//  DefaultProfileView.swift
//  Seerati
//
//  Path: Seerati/Features/Settings/Views/DefaultProfileView.swift
//
//  ─────────────────────────────────────────────────
//  AR: شاشة معلوماتي الافتراضية المحدثة
//  EN: Updated Default Profile Screen
//  ─────────────────────────────────────────────────

import SwiftUI
import PhotosUI

// MARK: - Default Profile View
struct DefaultProfileView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @AppStorage("defaultFullName") private var fullName = ""
    @AppStorage("defaultEmail") private var email = ""
    @AppStorage("defaultPhone") private var phone = ""
    @AppStorage("defaultLocation") private var location = ""
    @AppStorage("defaultLinkedIn") private var linkedin = ""
    @AppStorage("defaultWebsite") private var website = ""
    
    // ✅ NEW: Additional Personal Info
    @AppStorage("defaultNationality") private var nationality = ""
    @AppStorage("defaultGender") private var genderRaw = Gender.preferNotToSay.rawValue
    @AppStorage("defaultMaritalStatus") private var maritalStatusRaw = MaritalStatus.preferNotToSay.rawValue
    @AppStorage("defaultDrivingLicense") private var drivingLicenseRaw = DrivingLicense.none.rawValue
    @AppStorage("defaultVisaStatus") private var visaStatusRaw = VisaStatus.citizen.rawValue
    @AppStorage("defaultDateOfBirth") private var dateOfBirthTimestamp: Double = 0
    
    @State private var photoItem: PhotosPickerItem?
    @State private var profileImage: UIImage?
    @State private var showSavedToast = false
    @State private var showAdditionalInfo = false
    @State private var showDatePicker = false
    @State private var showNationalityPicker = false
    
    // MARK: - Computed Properties
    private var gender: Gender {
        get { Gender(rawValue: genderRaw) ?? .preferNotToSay }
        set { genderRaw = newValue.rawValue }
    }
    
    private var maritalStatus: MaritalStatus {
        get { MaritalStatus(rawValue: maritalStatusRaw) ?? .preferNotToSay }
        set { maritalStatusRaw = newValue.rawValue }
    }
    
    private var drivingLicense: DrivingLicense {
        get { DrivingLicense(rawValue: drivingLicenseRaw) ?? .none }
        set { drivingLicenseRaw = newValue.rawValue }
    }
    
    private var visaStatus: VisaStatus {
        get { VisaStatus(rawValue: visaStatusRaw) ?? .citizen }
        set { visaStatusRaw = newValue.rawValue }
    }
    
    private var dateOfBirth: Date? {
        get { dateOfBirthTimestamp > 0 ? Date(timeIntervalSince1970: dateOfBirthTimestamp) : nil }
        set { dateOfBirthTimestamp = newValue?.timeIntervalSince1970 ?? 0 }
    }
    
    private var formattedDateOfBirth: String {
        guard let dob = dateOfBirth else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ar")
        return formatter.string(from: dob)
    }
    
    private var age: Int? {
        guard let dob = dateOfBirth else { return nil }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dob, to: Date())
        return ageComponents.year
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Header
                    headerText
                    
                    // Photo
                    photoSection
                    
                    // Basic Info
                    basicInfoSection
                    
                    // Contact Info
                    contactInfoSection
                    
                    // ✅ NEW: Additional Personal Info
                    additionalInfoSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.top, AppSpacing.md)
            }
            .background(AppColors.background)
            .navigationTitle("معلوماتي الافتراضية")
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
                    Button("حفظ المعلومات") {
                        saveProfile()
                    }
                    .font(AppFonts.body(weight: .semibold))
                    .foregroundStyle(AppColors.primary)
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerSheet(selectedDate: Binding(
                    get: { dateOfBirth ?? Date() },
                    set: { dateOfBirthTimestamp = $0.timeIntervalSince1970 }
                ))
            }
            .sheet(isPresented: $showNationalityPicker) {
                NationalityPickerSheet(selectedNationality: $nationality)
            }
            .overlay {
                if showSavedToast {
                    savedToast
                }
            }
        }
        .onAppear {
            loadProfileImage()
        }
        .onChange(of: photoItem) {
            Task {
                await loadSelectedPhoto()
            }
        }
    }
    
    // MARK: - Header Text
    private var headerText: some View {
        Text("هذه المعلومات ستُستخدم لتعبئة السير الذاتية الجديدة تلقائياً")
            .font(AppFonts.caption())
            .foregroundStyle(AppColors.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
    
    // MARK: - Photo Section
    private var photoSection: some View {
        VStack(spacing: AppSpacing.sm) {
            PhotosPicker(selection: $photoItem, matching: .images) {
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(AppColors.primary, lineWidth: 3))
                } else {
                    Circle()
                        .fill(AppColors.surface)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(AppColors.textSecondary)
                        )
                }
            }
            
            if profileImage != nil {
                Button("إزالة الصورة") {
                    removePhoto()
                }
                .font(AppFonts.caption())
                .foregroundStyle(.red)
            }
        }
    }
    
    // MARK: - Basic Info Section
    private var basicInfoSection: some View {
        VStack(spacing: AppSpacing.md) {
            ProfileTextField(
                title: "الاسم الكامل",
                icon: "person.fill",
                placeholder: "أدخل اسمك الكامل",
                text: $fullName
            )
        }
    }
    
    // MARK: - Contact Info Section
    private var contactInfoSection: some View {
        VStack(spacing: AppSpacing.md) {
            ProfileTextField(
                title: "البريد الإلكتروني",
                icon: "envelope.fill",
                placeholder: "example@email.com",
                text: $email,
                keyboardType: .emailAddress
            )
            
            ProfileTextField(
                title: "رقم الهاتف",
                icon: "phone.fill",
                placeholder: "+966 50 000 0000",
                text: $phone,
                keyboardType: .phonePad
            )
            
            ProfileTextField(
                title: "الموقع",
                icon: "location.fill",
                placeholder: "المدينة، البلد",
                text: $location
            )
            
            ProfileTextField(
                title: "الموقع / LINKEDIN",
                icon: "link",
                placeholder: "https://...",
                text: $linkedin,
                keyboardType: .URL
            )
        }
    }
    
    // MARK: - Additional Info Section
    private var additionalInfoSection: some View {
        VStack(spacing: AppSpacing.md) {
            // Section Header
            HStack {
                Image(systemName: "person.text.rectangle")
                    .foregroundStyle(AppColors.primary)
                Text("معلومات إضافية")
                    .font(AppFonts.caption(weight: .semibold))
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                
                Button {
                    withAnimation {
                        showAdditionalInfo.toggle()
                    }
                } label: {
                    Image(systemName: showAdditionalInfo ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .padding(.top, AppSpacing.md)
            
            if showAdditionalInfo {
                VStack(spacing: AppSpacing.md) {
                    // تاريخ الميلاد
                    additionalInfoRow(
                        title: "تاريخ الميلاد",
                        icon: "calendar",
                        value: dateOfBirth != nil ? formattedDateOfBirth : "غير محدد",
                        trailing: age != nil ? "(\(age!) سنة)" : nil
                    ) {
                        showDatePicker = true
                    }
                    
                    // الجنسية
                    additionalInfoRow(
                        title: "الجنسية",
                        icon: "globe",
                        value: nationality.isEmpty ? "غير محددة" : nationality
                    ) {
                        showNationalityPicker = true
                    }
                    
                    // الجنس
                    additionalInfoPickerRow(
                        title: "الجنس",
                        icon: "person.fill",
                        options: [Gender.male, .female],
                        selection: Binding(
                            get: { gender },
                            set: { genderRaw = $0.rawValue }
                        ),
                        displayName: { $0.localizedName }
                    )
                    
                    // الحالة الاجتماعية
                    additionalInfoPickerRow(
                        title: "الحالة الاجتماعية",
                        icon: "heart.fill",
                        options: [MaritalStatus.single, .married, .divorced],
                        selection: Binding(
                            get: { maritalStatus },
                            set: { maritalStatusRaw = $0.rawValue }
                        ),
                        displayName: { $0.localizedName }
                    )
                    
                    // رخصة القيادة
                    additionalInfoPickerRow(
                        title: "رخصة القيادة",
                        icon: "car.fill",
                        options: [DrivingLicense.none, .car, .international],
                        selection: Binding(
                            get: { drivingLicense },
                            set: { drivingLicenseRaw = $0.rawValue }
                        ),
                        displayName: { $0.localizedName }
                    )
                    
                    // حالة الإقامة
                    additionalInfoPickerRow(
                        title: "حالة الإقامة",
                        icon: "doc.text.fill",
                        options: [VisaStatus.citizen, .resident, .transferable],
                        selection: Binding(
                            get: { visaStatus },
                            set: { visaStatusRaw = $0.rawValue }
                        ),
                        displayName: { $0.localizedName }
                    )
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Additional Info Row
    private func additionalInfoRow(
        title: String,
        icon: String,
        value: String,
        trailing: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(AppColors.primary)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
                
                Spacer()
                
                Text(value)
                    .font(AppFonts.body())
                    .foregroundStyle(AppColors.textPrimary)
                
                if let trailing = trailing {
                    Text(trailing)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.primary)
                }
                
                Image(systemName: "chevron.left")
                    .font(.system(size: 10))
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(.vertical, AppSpacing.xs)
        }
    }
    
    // MARK: - Additional Info Picker Row
    private func additionalInfoPickerRow<T: Hashable>(
        title: String,
        icon: String,
        options: [T],
        selection: Binding<T>,
        displayName: @escaping (T) -> String
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(AppColors.primary)
                .frame(width: 24)
            
            Text(title)
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
            
            Spacer()
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button {
                        selection.wrappedValue = option
                    } label: {
                        HStack {
                            Text(displayName(option))
                            if selection.wrappedValue == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(displayName(selection.wrappedValue))
                        .font(AppFonts.body())
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
    
    // MARK: - Saved Toast
    private var savedToast: some View {
        VStack {
            Spacer()
            
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("تم حفظ المعلومات")
                    .font(AppFonts.body(weight: .medium))
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .padding(.bottom, 100)
        }
    }
    
    // MARK: - Actions
    private func saveProfile() {
        saveProfileImage()
        
        withAnimation {
            showSavedToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSavedToast = false
            }
            dismiss()
        }
    }
    
    private func loadSelectedPhoto() async {
        guard let photoItem else { return }
        
        if let data = try? await photoItem.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            await MainActor.run {
                profileImage = image
            }
        }
    }
    
    private func removePhoto() {
        profileImage = nil
        photoItem = nil
        UserDefaults.standard.removeObject(forKey: "defaultProfileImage")
    }
    
    private func saveProfileImage() {
        if let image = profileImage,
           let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "defaultProfileImage")
        }
    }
    
    private func loadProfileImage() {
        if let data = UserDefaults.standard.data(forKey: "defaultProfileImage"),
           let image = UIImage(data: data) {
            profileImage = image
        }
    }
}

// MARK: - Profile Text Field
struct ProfileTextField: View {
    let title: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
            
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: 24)
                
                TextField(placeholder, text: $text)
                    .font(AppFonts.body())
                    .keyboardType(keyboardType)
                    .textContentType(contentType)
            }
            .padding()
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var contentType: UITextContentType? {
        switch keyboardType {
        case .emailAddress: return .emailAddress
        case .phonePad: return .telephoneNumber
        case .URL: return .URL
        default: return nil
        }
    }
}

// MARK: - Preview
#Preview {
    DefaultProfileView()
}
