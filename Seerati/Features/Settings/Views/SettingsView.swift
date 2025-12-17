//
//  SettingsView.swift
//  Seerati
//
//  Path: Seerati/Features/Settings/Views/SettingsView.swift
//
//  ─────────────────────────────────────────────
//  AR: شاشة الإعدادات الرئيسية
//  EN: Main settings screen
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SettingsViewModel()
    
    // Sheets
    @State private var showDefaultInfo = false
    @State private var showPremiumPlans = false
    @State private var showThemePicker = false
    @State private var showLanguagePicker = false
    @State private var showQualityPicker = false
    @State private var showPageSizePicker = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Premium Card
                    PremiumCard(isPremium: viewModel.isPremium) {
                        showPremiumPlans = true
                    }
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                    
                    // Sections
                    VStack(spacing: AppSpacing.md) {
                        // Account Section
                        accountSection
                        
                        // Appearance Section
                        appearanceSection
                        
                        // Export Section
                        exportSection
                        
                        // About Section
                        aboutSection
                    }
                }
                .padding(.vertical, AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle(SettingsStrings.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(SettingsStrings.done) {
                        dismiss()
                    }
                    .foregroundStyle(AppColors.primary)
                }
            }
        }
        .sheet(isPresented: $showDefaultInfo) {
            DefaultInfoView()
        }
        .sheet(isPresented: $showPremiumPlans) {
            PremiumPlansSheet { yearly in
                await viewModel.purchasePremium(yearly: yearly)
            }
        }
        .sheet(isPresented: $showThemePicker) {
            ThemePickerSheet(selectedTheme: $viewModel.currentTheme)
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerSheet()
        }
        .sheet(isPresented: $showQualityPicker) {
            QualityPickerSheet(selectedQuality: $viewModel.exportQuality)
        }
        .sheet(isPresented: $showPageSizePicker) {
            PageSizePickerSheet(selectedSize: $viewModel.pageSize)
        }
        .alert(SettingsStrings.restoreSuccess, isPresented: $viewModel.showRestoreSuccess) {
            Button("OK", role: .cancel) {}
        }
        .alert(SettingsStrings.restoreFailed, isPresented: $viewModel.showRestoreError) {
            Button("OK", role: .cancel) {}
        }
    }
    
    // MARK: - Account Section
    private var accountSection: some View {
        SettingsSection(title: SettingsStrings.account) {
            // Default Info
            SettingsRow(
                icon: "person.fill",
                title: SettingsStrings.defaultInfo,
                showArrow: true
            ) {
                showDefaultInfo = true
            }
            
            // Restore Purchases
            SettingsRow(
                icon: "arrow.clockwise",
                title: viewModel.isRestoring ? SettingsStrings.restoring : SettingsStrings.restorePurchases,
                showArrow: false
            ) {
                Task {
                    await viewModel.restorePurchases()
                }
            }
            .disabled(viewModel.isRestoring)
        }
    }
    
    // MARK: - Appearance Section
    private var appearanceSection: some View {
        SettingsSection(title: SettingsStrings.appearance) {
            // Theme
            SettingsRow(
                icon: "paintbrush.fill",
                title: SettingsStrings.theme,
                value: viewModel.currentTheme.displayName,
                showArrow: true
            ) {
                showThemePicker = true
            }
            
            // Language
            SettingsRow(
                icon: "globe",
                title: SettingsStrings.language,
                value: viewModel.currentLanguage.nativeName,
                showArrow: true
            ) {
                showLanguagePicker = true
            }
        }
    }
    
    // MARK: - Export Section
    private var exportSection: some View {
        SettingsSection(title: SettingsStrings.export) {
            // Exports Remaining
            if !viewModel.isPremium {
                SettingsRow(
                    icon: "square.and.arrow.down",
                    title: SettingsStrings.exportsRemaining,
                    value: viewModel.exportsText,
                    showArrow: false
                ) {}
            }
            
            // PDF Quality
            SettingsRow(
                icon: "doc.fill",
                title: SettingsStrings.pdfQuality,
                value: viewModel.exportQuality.localizedName,
                showArrow: true
            ) {
                showQualityPicker = true
            }
            
            // Page Size
            SettingsRow(
                icon: "doc.plaintext",
                title: SettingsStrings.pageSize,
                value: viewModel.pageSize.displayName,
                showArrow: true
            ) {
                showPageSizePicker = true
            }
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        SettingsSection(title: SettingsStrings.about) {
            // Version
            SettingsRow(
                icon: "info.circle.fill",
                title: SettingsStrings.version,
                value: viewModel.appVersion,
                showArrow: false
            ) {}
            
            // Privacy Policy
            SettingsRow(
                icon: "shield.fill",
                title: SettingsStrings.privacyPolicy,
                showArrow: true
            ) {
                openURL("https://seerati.app/privacy")
            }
            
            // Terms of Use
            SettingsRow(
                icon: "doc.text.fill",
                title: SettingsStrings.termsOfUse,
                showArrow: true
            ) {
                openURL("https://seerati.app/terms")
            }
            
            // Contact Us
            SettingsRow(
                icon: "envelope.fill",
                title: SettingsStrings.contactUs,
                showArrow: true
            ) {
                openEmail()
            }
        }
    }
    
    // MARK: - Helpers
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "mailto:support@seerati.app") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Settings Section
struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title.uppercased())
                .font(AppFonts.caption(weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.screenHorizontal)
            
            VStack(spacing: 0) {
                content()
            }
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            .padding(.horizontal, AppSpacing.screenHorizontal)
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    var value: String? = nil
    var showArrow: Bool = true
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppFonts.body())
                    .foregroundStyle(AppColors.textPrimary)
                
                Spacer()
                
                if let value = value {
                    Text(value)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Theme Picker Sheet
struct ThemePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTheme: AppThemeMode
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(AppThemeMode.allCases) { theme in
                    Button {
                        selectedTheme = theme
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: theme.icon)
                                .foregroundStyle(AppColors.textSecondary)
                            
                            Text(theme.displayName)
                                .foregroundStyle(AppColors.textPrimary)
                            
                            Spacer()
                            
                            if selectedTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppColors.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle(SettingsStrings.theme)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(SettingsStrings.done) { dismiss() }
                }
            }
        }
        .presentationDetents([.height(250)])
    }
}

// MARK: - Quality Picker Sheet
struct QualityPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedQuality: ExportQuality
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ExportQuality.allCases, id: \.self) { quality in
                    Button {
                        selectedQuality = quality
                        dismiss()
                    } label: {
                        HStack {
                            Text(quality.localizedName)
                                .foregroundStyle(AppColors.textPrimary)
                            
                            Spacer()
                            
                            if selectedQuality == quality {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppColors.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle(SettingsStrings.pdfQuality)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(SettingsStrings.done) { dismiss() }
                }
            }
        }
        .presentationDetents([.height(220)])
    }
}

// MARK: - Page Size Picker Sheet
struct PageSizePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedSize: PageSize
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(PageSize.allCases) { size in
                    Button {
                        selectedSize = size
                        dismiss()
                    } label: {
                        HStack {
                            Text(size.displayName)
                                .foregroundStyle(AppColors.textPrimary)
                            
                            Spacer()
                            
                            if selectedSize == size {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppColors.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle(SettingsStrings.pageSize)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(SettingsStrings.done) { dismiss() }
                }
            }
        }
        .presentationDetents([.height(220)])
    }
}

// MARK: - Export Quality Extension
extension ExportQuality {
    var localizedName: String {
        LocalizationManager.shared.isArabic ? arabicName : displayName
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
