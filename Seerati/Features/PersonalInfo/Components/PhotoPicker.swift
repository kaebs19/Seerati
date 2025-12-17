//
//  PhotoPicker.swift
//  Seerati
//
//  Path: Seerati/Features/PersonalInfo/Components/PhotoPicker.swift
//
//  ─────────────────────────────────────────────
//  AR: مكون اختيار وعرض الصورة الشخصية
//  EN: Profile photo picker and display component
//  ─────────────────────────────────────────────

import SwiftUI
import PhotosUI

// MARK: - Photo Picker View
struct PhotoPickerView: View {
    
    // MARK: - Properties
    @Binding var photoData: Data?
    @Binding var selectedItem: PhotosPickerItem?
    var onRemove: () -> Void
    
    @State private var showOptions = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            // Photo Circle
            photoCircle
            
            // Action Button
            actionButton
        }
    }
    
    // MARK: - Photo Circle
    private var photoCircle: some View {
        ZStack {
            if let data = photoData, let uiImage = UIImage(data: data) {
                // Show Photo
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .onTapGesture {
                        showOptions = true
                    }
            } else {
                // Placeholder - Wrapped in PhotosPicker for direct selection
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack {
                        Circle()
                            .fill(AppColors.surface)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(AppColors.textSecondary)
                            )
                        
                        // Camera Badge
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(AppColors.textOnPrimary)
                            )
                            .offset(x: 35, y: 35)
                    }
                }
            }
        }
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Group {
            if photoData != nil {
                // Change/Remove Options
                Button {
                    showOptions = true
                } label: {
                    Text(PersonalInfoStrings.changePhoto)
                        .font(AppFonts.subheadline(weight: .medium))
                        .foregroundStyle(AppColors.primary)
                }
                .confirmationDialog("Photo Options", isPresented: $showOptions) {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images
                    ) {
                        Text(PersonalInfoStrings.changePhoto)
                    }
                    
                    Button(PersonalInfoStrings.removePhoto, role: .destructive) {
                        onRemove()
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
            } else {
                // Upload Button
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images
                ) {
                    Text(PersonalInfoStrings.uploadPhoto)
                        .font(AppFonts.subheadline(weight: .medium))
                        .foregroundStyle(AppColors.primary)
                }
            }
        }
    }
}

// MARK: - Small Photo View
struct SmallPhotoView: View {
    
    let photoData: Data?
    var size: CGFloat = 48
    
    var body: some View {
        Group {
            if let data = photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(AppColors.surface)
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: size * 0.4))
                            .foregroundStyle(AppColors.textSecondary)
                    )
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 32) {
        PhotoPickerView(
            photoData: .constant(nil),
            selectedItem: .constant(nil),
            onRemove: {}
        )
        
        SmallPhotoView(photoData: nil)
        
        SmallPhotoView(photoData: nil, size: 80)
    }
    .padding()
    .background(AppColors.background)
}
