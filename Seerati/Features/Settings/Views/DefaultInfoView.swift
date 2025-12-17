//
//  DefaultInfoView.swift
//  Seerati
//
//  Path: Seerati/Features/Settings/Views/DefaultInfoView.swift
//
//  ─────────────────────────────────────────────
//  AR: شاشة معلومات المستخدم الافتراضية
//  EN: User default information screen
//  ─────────────────────────────────────────────

import SwiftUI
import PhotosUI

// MARK: - Default Info View
struct DefaultInfoView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = DefaultInfoViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Subtitle
                    Text(DefaultInfoStrings.subtitle)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Photo
                    photoSection
                    
                    // Form
                    formSection
                }
                .padding(.vertical, AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle(DefaultInfoStrings.title)
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
                    Button(DefaultInfoStrings.save) {
                        viewModel.save()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primary)
                }
            }
            .onChange(of: viewModel.selectedPhotoItem) { _, _ in
                Task {
                    await viewModel.loadPhoto()
                }
            }
        }
    }
    
    // MARK: - Photo Section
    private var photoSection: some View {
        VStack(spacing: AppSpacing.sm) {
            // Photo
            PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images) {
                if let data = viewModel.photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    ZStack {
                        Circle()
                            .fill(AppColors.surface)
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
            
            // Remove Photo
            if viewModel.photoData != nil {
                Button {
                    viewModel.removePhoto()
                } label: {
                    Text(PersonalInfoStrings.removePhoto)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.error)
                }
            }
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: AppSpacing.inputSpacing) {
            InputField(
                label: DefaultInfoStrings.fullName,
                placeholder: PersonalInfoStrings.fullNamePlaceholder,
                icon: "person.fill",
                text: $viewModel.fullName,
                textContentType: .name
            )
            
            InputField(
                label: DefaultInfoStrings.email,
                placeholder: PersonalInfoStrings.emailPlaceholder,
                icon: "envelope.fill",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                textContentType: .emailAddress
            )
            
            InputField(
                label: DefaultInfoStrings.phone,
                placeholder: PersonalInfoStrings.phonePlaceholder,
                icon: "phone.fill",
                text: $viewModel.phone,
                keyboardType: .phonePad,
                textContentType: .telephoneNumber
            )
            
            InputField(
                label: DefaultInfoStrings.location,
                placeholder: PersonalInfoStrings.locationPlaceholder,
                icon: "location.fill",
                text: $viewModel.location,
                textContentType: .fullStreetAddress
            )
            
            InputField(
                label: DefaultInfoStrings.website,
                placeholder: PersonalInfoStrings.websitePlaceholder,
                icon: "link",
                text: $viewModel.website,
                keyboardType: .URL,
                textContentType: .URL
            )
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
    }
}

// MARK: - Default Info ViewModel
@Observable
final class DefaultInfoViewModel {
    
    // MARK: - Properties
    var fullName: String = ""
    var email: String = ""
    var phone: String = ""
    var location: String = ""
    var website: String = ""
    var photoData: Data?
    var selectedPhotoItem: PhotosPickerItem?
    
    // MARK: - Init
    init() {
        loadSavedInfo()
    }
    
    // MARK: - Methods
    
    /// تحميل المعلومات المحفوظة
    func loadSavedInfo() {
        let defaults = UserDefaultsManager.shared
        fullName = defaults.userName ?? ""
        email = defaults.userEmail ?? ""
        phone = defaults.userPhone ?? ""
        location = defaults.userLocation ?? ""
        website = defaults.userWebsite ?? ""
        photoData = defaults.userPhotoData
    }
    
    /// حفظ المعلومات
    func save() {
        let defaults = UserDefaultsManager.shared
        defaults.userName = fullName.isEmpty ? nil : fullName
        defaults.userEmail = email.isEmpty ? nil : email
        defaults.userPhone = phone.isEmpty ? nil : phone
        defaults.userLocation = location.isEmpty ? nil : location
        defaults.userWebsite = website.isEmpty ? nil : website
        defaults.userPhotoData = photoData
    }
    
    /// تحميل الصورة
    @MainActor
    func loadPhoto() async {
        guard let item = selectedPhotoItem else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data),
                   let compressed = uiImage.jpegData(compressionQuality: 0.7) {
                    photoData = compressed
                } else {
                    photoData = data
                }
            }
        } catch {
            print("Failed to load photo: \(error)")
        }
    }
    
    /// إزالة الصورة
    func removePhoto() {
        photoData = nil
        selectedPhotoItem = nil
    }
}

// MARK: - Preview
#Preview {
    DefaultInfoView()
}
