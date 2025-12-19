//
//  MyCVsView.swift
//  Seerati
//
//  Path: Seerati/Features/MyCVs/Views/MyCVsView.swift
//
//  ─────────────────────────────────────────────────
//  AR: شاشة سيرتي الذاتية
//  EN: My CVs Screen
//  ─────────────────────────────────────────────────

import SwiftUI
import SwiftData

// MARK: - My CVs View
struct MyCVsView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CVData.updatedAt, order: .reverse) private var cvs: [CVData]
    
    @State private var searchText = ""
    @State private var showCreateCV = false
    @State private var selectedCV: CVData?
    @State private var showDeleteAlert = false
    @State private var cvToDelete: CVData?
    
    // MARK: - Filtered CVs
    private var filteredCVs: [CVData] {
        if searchText.isEmpty {
            return cvs
        }
        return cvs.filter { cv in
            cv.cvName.localizedCaseInsensitiveContains(searchText) ||
            cv.fullName.localizedCaseInsensitiveContains(searchText) ||
            cv.jobTitle.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                if cvs.isEmpty {
                    emptyStateView
                } else {
                    cvListView
                }
            }
            .navigationTitle(MyCVsStrings.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(MyCVsStrings.done) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreateCV = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchText, prompt: MyCVsStrings.searchPlaceholder)
            .sheet(isPresented: $showCreateCV) {
                MyCVsCreateSheet()
            }
            .sheet(item: $selectedCV) { cv in
                NavigationStack {
                    CVPreviewView(cv: cv)
                }
            }
            .alert(MyCVsStrings.deleteTitle, isPresented: $showDeleteAlert) {
                Button(MyCVsStrings.cancel, role: .cancel) { }
                Button(MyCVsStrings.delete, role: .destructive) {
                    if let cv = cvToDelete {
                        deleteCV(cv)
                    }
                }
            } message: {
                Text(MyCVsStrings.deleteMessage)
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 60))
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            
            Text(MyCVsStrings.noCVs)
                .font(AppFonts.title3(weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)
            
            Text(MyCVsStrings.createFirst)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.textSecondary)
            
            Button {
                showCreateCV = true
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text(MyCVsStrings.createCV)
                }
                .font(AppFonts.body(weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.vertical, AppSpacing.md)
                .background(AppColors.primary)
                .clipShape(Capsule())
            }
        }
    }
    
    // MARK: - CV List
    private var cvListView: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(filteredCVs) { cv in
                    MyCVsCardView(cv: cv)
                        .onTapGesture {
                            selectedCV = cv
                        }
                        .contextMenu {
                            Button {
                                selectedCV = cv
                            } label: {
                                Label(MyCVsStrings.preview, systemImage: "eye")
                            }
                            
                            Button {
                                duplicateCV(cv)
                            } label: {
                                Label(MyCVsStrings.duplicate, systemImage: "doc.on.doc")
                            }
                            
                            Divider()
                            
                            Button(role: .destructive) {
                                cvToDelete = cv
                                showDeleteAlert = true
                            } label: {
                                Label(MyCVsStrings.delete, systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.vertical, AppSpacing.md)
        }
    }
    
    // MARK: - Actions
    private func deleteCV(_ cv: CVData) {
        withAnimation {
            modelContext.delete(cv)
        }
    }
    
    private func duplicateCV(_ cv: CVData) {
        let newCV = CVData(cvName: "\(cv.cvName) - \(MyCVsStrings.copy)")
        newCV.fullName = cv.fullName
        newCV.jobTitle = cv.jobTitle
        newCV.email = cv.email
        newCV.phone = cv.phone
        newCV.location = cv.location
        newCV.website = cv.website
        newCV.summary = cv.summary
        newCV.photoData = cv.photoData
        
        modelContext.insert(newCV)
    }
}

// MARK: - CV Card View
struct MyCVsCardView: View {
    let cv: CVData
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.surface)
                    .frame(width: 60, height: 80)
                
                if let data = cv.photoData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(AppColors.primary.opacity(0.5))
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(cv.cvName)
                    .font(AppFonts.body(weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)
                
                if !cv.jobTitle.isEmpty {
                    Text(cv.jobTitle)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textSecondary)
                        .lineLimit(1)
                }
                
                Text(cv.lastEditedText)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: LocalizationManager.shared.isArabic ? "chevron.left" : "chevron.right")
                .font(.system(size: 14))
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Create CV Sheet
struct MyCVsCreateSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var cvName = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                // Icon
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 50))
                    .foregroundStyle(AppColors.primary)
                    .padding(.top, AppSpacing.xl)
                
                // Title
                Text(MyCVsStrings.newCV)
                    .font(AppFonts.title2())
                
                // Input
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(MyCVsStrings.cvName)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                    
                    TextField(MyCVsStrings.cvNamePlaceholder, text: $cvName)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(AppColors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                
                Spacer()
                
                // Create Button
                Button {
                    createCV()
                } label: {
                    Text(MyCVsStrings.create)
                        .font(AppFonts.body(weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(cvName.isEmpty ? AppColors.textSecondary : AppColors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(cvName.isEmpty)
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.bottom, AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(MyCVsStrings.cancel) {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private func createCV() {
        let cv = CVData(cvName: cvName)
        modelContext.insert(cv)
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    MyCVsView()
        .modelContainer(for: CVData.self, inMemory: true)
}
