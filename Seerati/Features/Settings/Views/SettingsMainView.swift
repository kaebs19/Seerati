//
//  SettingsMainView.swift
//  Seerati
//
//  Path: Seerati/Features/Settings/Views/SettingsMainView.swift
//
//  ─────────────────────────────────────────────────
//  AR: شاشة الإعدادات الرئيسية
//  EN: Main Settings Screen
//  ─────────────────────────────────────────────────

import SwiftUI

// MARK: - Settings Strings
private enum SettingsViewStrings {
    static var title: String {
        LocalizationManager.shared.isArabic ? "الإعدادات" : "Settings"
    }
    
    static var done: String {
        LocalizationManager.shared.isArabic ? "تم" : "Done"
    }
    
    // Profile Section
    static var profile: String {
        LocalizationManager.shared.isArabic ? "الملف الشخصي" : "Profile"
    }
    
    static var defaultInfo: String {
        LocalizationManager.shared.isArabic ? "معلوماتي الافتراضية" : "My Default Info"
    }
    
    static var autoFill: String {
        LocalizationManager.shared.isArabic ? "للتعبئة التلقائية" : "For auto-fill"
    }
    
    // App Section
    static var app: String {
        LocalizationManager.shared.isArabic ? "التطبيق" : "App"
    }
    
    static var language: String {
        LocalizationManager.shared.isArabic ? "اللغة" : "Language"
    }
    
    static var appearance: String {
        LocalizationManager.shared.isArabic ? "المظهر" : "Appearance"
    }
    
    static var automatic: String {
        LocalizationManager.shared.isArabic ? "تلقائي" : "Automatic"
    }
    
    static var notifications: String {
        LocalizationManager.shared.isArabic ? "الإشعارات" : "Notifications"
    }
    
    static var enabled: String {
        LocalizationManager.shared.isArabic ? "مفعّل" : "Enabled"
    }
    
    static var disabled: String {
        LocalizationManager.shared.isArabic ? "معطّل" : "Disabled"
    }
    
    // Storage Section
    static var storage: String {
        LocalizationManager.shared.isArabic ? "التخزين" : "Storage"
    }
    
    static var storageUsed: String {
        LocalizationManager.shared.isArabic ? "المساحة المستخدمة" : "Storage Used"
    }
    
    static var resetSettings: String {
        LocalizationManager.shared.isArabic ? "إعادة ضبط الإعدادات" : "Reset Settings"
    }
    
    static var deleteAllData: String {
        LocalizationManager.shared.isArabic ? "حذف جميع البيانات" : "Delete All Data"
    }
    
    // About Section
    static var about: String {
        LocalizationManager.shared.isArabic ? "حول التطبيق" : "About"
    }
    
    static var version: String {
        LocalizationManager.shared.isArabic ? "الإصدار" : "Version"
    }
    
    static var rateApp: String {
        LocalizationManager.shared.isArabic ? "قيّم التطبيق" : "Rate App"
    }
    
    static var shareApp: String {
        LocalizationManager.shared.isArabic ? "شارك التطبيق" : "Share App"
    }
    
    // Alerts
    static var deleteAllTitle: String {
        LocalizationManager.shared.isArabic ? "حذف جميع البيانات" : "Delete All Data"
    }
    
    static var deleteAllMessage: String {
        LocalizationManager.shared.isArabic
            ? "سيتم حذف جميع السير الذاتية والإعدادات. لا يمكن التراجع عن هذا الإجراء."
            : "All CVs and settings will be deleted. This action cannot be undone."
    }
    
    static var resetTitle: String {
        LocalizationManager.shared.isArabic ? "إعادة ضبط الإعدادات" : "Reset Settings"
    }
    
    static var resetMessage: String {
        LocalizationManager.shared.isArabic
            ? "سيتم إعادة جميع الإعدادات إلى القيم الافتراضية."
            : "All settings will be reset to default values."
    }
    
    static var reset: String {
        LocalizationManager.shared.isArabic ? "إعادة ضبط" : "Reset"
    }
    
    static var delete: String {
        LocalizationManager.shared.isArabic ? "حذف" : "Delete"
    }
    
    static var cancel: String {
        LocalizationManager.shared.isArabic ? "إلغاء" : "Cancel"
    }
}

// MARK: - Settings Main View
struct SettingsMainView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    @State private var showProfile = false
    @State private var showLanguagePicker = false
    @State private var showDeleteAlert = false
    @State private var showResetAlert = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    Button {
                        showProfile = true
                    } label: {
                        SettingsRow(
                            icon: "person.fill",
                            iconColor: .blue,
                            title: SettingsViewStrings.defaultInfo,
                            subtitle: SettingsViewStrings.autoFill
                        )
                    }
                } header: {
                    Text(SettingsViewStrings.profile)
                }
                
                // App Section
                Section {
                    Button {
                        showLanguagePicker = true
                    } label: {
                        SettingsRow(
                            icon: "globe",
                            iconColor: .green,
                            title: SettingsViewStrings.language,
                            value: LocalizationManager.shared.currentLanguage.nativeName
                        )
                    }
                    
                    SettingsRow(
                        icon: "paintbrush.fill",
                        iconColor: .purple,
                        title: SettingsViewStrings.appearance,
                        value: SettingsViewStrings.automatic
                    )
                    
                    Toggle(isOn: $notificationsEnabled) {
                        SettingsRow(
                            icon: "bell.fill",
                            iconColor: .red,
                            title: SettingsViewStrings.notifications
                        )
                    }
                    .tint(AppColors.primary)
                } header: {
                    Text(SettingsViewStrings.app)
                }
                
                // Storage Section
                Section {
                    SettingsRow(
                        icon: "internaldrive.fill",
                        iconColor: .orange,
                        title: SettingsViewStrings.storageUsed,
                        value: calculateStorageUsed()
                    )
                    
                    Button {
                        showResetAlert = true
                    } label: {
                        SettingsRow(
                            icon: "arrow.counterclockwise",
                            iconColor: .gray,
                            title: SettingsViewStrings.resetSettings
                        )
                    }
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        SettingsRow(
                            icon: "trash.fill",
                            iconColor: .red,
                            title: SettingsViewStrings.deleteAllData,
                            titleColor: .red
                        )
                    }
                } header: {
                    Text(SettingsViewStrings.storage)
                }
                
                // About Section
                Section {
                    SettingsRow(
                        icon: "info.circle.fill",
                        iconColor: .blue,
                        title: SettingsViewStrings.version,
                        value: AppActions.shared.fullVersion
                    )
                    
                    Button {
                        AppActions.shared.openAppStoreReview()
                    } label: {
                        SettingsRow(
                            icon: "star.fill",
                            iconColor: .yellow,
                            title: SettingsViewStrings.rateApp
                        )
                    }
                    
                    Button {
                        AppActions.shared.shareApp()
                    } label: {
                        SettingsRow(
                            icon: "square.and.arrow.up",
                            iconColor: .blue,
                            title: SettingsViewStrings.shareApp
                        )
                    }
                } header: {
                    Text(SettingsViewStrings.about)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(SettingsViewStrings.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(SettingsViewStrings.done) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
            }
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerSheet()
            }
            .alert(SettingsViewStrings.deleteAllTitle, isPresented: $showDeleteAlert) {
                Button(SettingsViewStrings.cancel, role: .cancel) { }
                Button(SettingsViewStrings.delete, role: .destructive) {
                    deleteAllData()
                }
            } message: {
                Text(SettingsViewStrings.deleteAllMessage)
            }
            .alert(SettingsViewStrings.resetTitle, isPresented: $showResetAlert) {
                Button(SettingsViewStrings.cancel, role: .cancel) { }
                Button(SettingsViewStrings.reset, role: .destructive) {
                    resetSettings()
                }
            } message: {
                Text(SettingsViewStrings.resetMessage)
            }
        }
    }
    
    // MARK: - Methods
    private func calculateStorageUsed() -> String {
        // حساب المساحة المستخدمة تقريبياً
        let defaults = UserDefaults.standard
        var totalSize: Int64 = 0
        
        if let imageData = defaults.data(forKey: "defaultProfileImage") {
            totalSize += Int64(imageData.count)
        }
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        
        return formatter.string(fromByteCount: totalSize)
    }
    
    private func deleteAllData() {
        // حذف جميع البيانات من UserDefaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    private func resetSettings() {
        // إعادة ضبط الإعدادات فقط
        UserDefaults.standard.set(true, forKey: "notificationsEnabled")
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    var subtitle: String? = nil
    var value: String? = nil
    var titleColor: Color = AppColors.textPrimary
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            // Title & Subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.body())
                    .foregroundStyle(titleColor)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            // Value
            if let value = value {
                Text(value)
                    .font(AppFonts.body())
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .contentShape(Rectangle())
    }
}
/*
// MARK: - Language Picker Sheet (moved here for convenience)
struct LanguagePickerSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Language.allCases) { language in
                    Button {
                        LocalizationManager.shared.setLanguage(language)
                        dismiss()
                    } label: {
                        HStack {
                            Text(language.flagEmoji)
                            Text(language.nativeName)
                                .foregroundStyle(AppColors.textPrimary)
                            
                            Spacer()
                            
                            if LocalizationManager.shared.currentLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppColors.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle(LocalizationManager.shared.isArabic ? "اللغة" : "Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(LocalizationManager.shared.isArabic ? "تم" : "Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
 */

// MARK: - Preview
#Preview {
    SettingsMainView()
}
