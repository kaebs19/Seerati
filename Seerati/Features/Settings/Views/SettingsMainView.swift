//
//  SettingsMainView.swift
//  Seerati
//
//  Path: Seerati/Features/Settings/Views/SettingsMainView.swift
//
//  ─────────────────────────────────────────────────
//  AR: شاشة الإعدادات الرئيسية - محدث مع Premium
//  EN: Main Settings Screen - Updated with Premium
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
    
    // Premium Section
    static var upgradeToPremium: String {
        LocalizationManager.shared.isArabic ? "ترقية للنسخة المميزة" : "Upgrade to Premium"
    }
    
    static var unlockFeatures: String {
        LocalizationManager.shared.isArabic ? "افتح جميع المميزات" : "Unlock all features"
    }
    
    static var youArePremium: String {
        LocalizationManager.shared.isArabic ? "أنت مشترك مميز" : "You're Premium"
    }
    
    static var enjoyFeatures: String {
        LocalizationManager.shared.isArabic ? "استمتع بجميع المميزات" : "Enjoy all features"
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
    
    // Legal Section
    static var legal: String {
        LocalizationManager.shared.isArabic ? "قانوني" : "Legal"
    }
    
    static var termsOfUse: String {
        LocalizationManager.shared.isArabic ? "شروط الاستخدام" : "Terms of Use"
    }
    
    static var privacyPolicy: String {
        LocalizationManager.shared.isArabic ? "سياسة الخصوصية" : "Privacy Policy"
    }
    
    static var contactUs: String {
        LocalizationManager.shared.isArabic ? "اتصل بنا" : "Contact Us"
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
    
    static var restorePurchases: String {
        LocalizationManager.shared.isArabic ? "استعادة المشتريات" : "Restore Purchases"
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
    
    static var restoreSuccess: String {
        LocalizationManager.shared.isArabic ? "تم استعادة المشتريات" : "Purchases Restored"
    }
    
    static var restoreError: String {
        LocalizationManager.shared.isArabic ? "لم يتم العثور على مشتريات" : "No Purchases Found"
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
    @State private var showPremiumView = false
    @State private var isRestoring = false
    @State private var showRestoreSuccess = false
    @State private var showRestoreError = false
    
    // Legal Sheets
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var showContact = false
    
    @State private var showThemePicker = false

    
    private let purchaseManager = PurchaseManager.shared
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                // ═══════════════════════════════════════════
                // MARK: - ✅ Premium Card Section
                // ═══════════════════════════════════════════
                Section {
                    premiumCardButton
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
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
                    // Language
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
                    
                    // ✅ Appearance - مع اختيار الثيم
                    Button {
                        showThemePicker = true
                    } label: {
                        SettingsRow(
                            icon: "paintbrush.fill",
                            iconColor: .purple,
                            title: SettingsViewStrings.appearance,
                            value: ThemeManager.shared.currentTheme.displayName
                        )
                    }
                    
                    // Notifications
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

                
                // Legal Section
                Section {
                    Button {
                        showTerms = true
                    } label: {
                        SettingsRow(
                            icon: "doc.text.fill",
                            iconColor: .gray,
                            title: SettingsViewStrings.termsOfUse
                        )
                    }
                    
                    Button {
                        showPrivacy = true
                    } label: {
                        SettingsRow(
                            icon: "hand.raised.fill",
                            iconColor: .blue,
                            title: SettingsViewStrings.privacyPolicy
                        )
                    }
                    
                    Button {
                        showContact = true
                    } label: {
                        SettingsRow(
                            icon: "envelope.fill",
                            iconColor: .orange,
                            title: SettingsViewStrings.contactUs
                        )
                    }
                } header: {
                    Text(SettingsViewStrings.legal)
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
                    
                    // Restore Purchases
                    Button {
                        Task {
                            await restorePurchases()
                        }
                    } label: {
                        HStack {
                            SettingsRow(
                                icon: "arrow.clockwise",
                                iconColor: .purple,
                                title: SettingsViewStrings.restorePurchases
                            )
                            
                            if isRestoring {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                        }
                    }
                    .disabled(isRestoring)
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
            // Sheets
            .sheet(isPresented: $showProfile) {
                ProfileView()
            }
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerSheet()
            }
            .sheet(isPresented: $showPremiumView) {
                PremiumView()
            }
            .sheet(isPresented: $showTerms) {
                WebViewScreen(title: SettingsViewStrings.termsOfUse, url: AppURLs.termsOfUse)
            }
            .sheet(isPresented: $showPrivacy) {
                WebViewScreen(title: SettingsViewStrings.privacyPolicy, url: AppURLs.privacyPolicy)
            }
            .sheet(isPresented: $showContact) {
                WebViewScreen(title: SettingsViewStrings.contactUs, url: AppURLs.contactUs)
            }
            
            .sheet(isPresented: $showThemePicker) {
                ThemePickerSheet()
            }
            
            // Alerts
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
            .alert(SettingsViewStrings.restoreSuccess, isPresented: $showRestoreSuccess) {
                Button("OK", role: .cancel) {}
            }
            .alert(SettingsViewStrings.restoreError, isPresented: $showRestoreError) {
                Button("OK", role: .cancel) {}
            }
        }
    }
    
    // ═══════════════════════════════════════════
    // MARK: - ✅ Premium Card Button
    // ═══════════════════════════════════════════
    private var premiumCardButton: some View {
        Button {
            showPremiumView = true
        } label: {
            if purchaseManager.isPremium {
                // Premium Active Card
                HStack(spacing: 14) {
                    // Crown Icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(SettingsViewStrings.youArePremium)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text(SettingsViewStrings.enjoyFeatures)
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.yellow)
                }
                .padding(16)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                // Upgrade Card
                HStack(spacing: 14) {
                    // Crown Icon with glow
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                            .shadow(color: .yellow.opacity(0.4), radius: 8)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(SettingsViewStrings.upgradeToPremium)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text(SettingsViewStrings.unlockFeatures)
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(16)
                .background(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - Methods
    private func calculateStorageUsed() -> String {
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
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    private func resetSettings() {
        UserDefaults.standard.set(true, forKey: "notificationsEnabled")
    }
    
    private func restorePurchases() async {
        isRestoring = true
        
        let success = await purchaseManager.restorePurchases()
        
        await MainActor.run {
            isRestoring = false
            if success {
                showRestoreSuccess = true
            } else {
                showRestoreError = true
            }
        }
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

// MARK: - Theme Picker Sheet
struct ThemePickerSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTheme = ThemeManager.shared.currentTheme
    
    private var isArabic: Bool {
        LocalizationManager.shared.isArabic
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(AppThemeMode.allCases) { theme in
                    Button {
                        selectedTheme = theme
                        ThemeManager.shared.setTheme(theme)
                    } label: {
                        HStack(spacing: 14) {
                            // Icon
                            Image(systemName: theme.icon)
                                .font(.system(size: 18))
                                .foregroundStyle(iconColor(for: theme))
                                .frame(width: 32, height: 32)
                                .background(iconColor(for: theme).opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            // Name
                            Text(theme.displayName)
                                .font(AppFonts.body())
                                .foregroundStyle(AppColors.textPrimary)
                            
                            Spacer()
                            
                            // Checkmark
                            if selectedTheme == theme {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(AppColors.primary)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(isArabic ? "المظهر" : "Appearance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isArabic ? "تم" : "Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private func iconColor(for theme: AppThemeMode) -> Color {
        switch theme {
        case .system: return .blue
        case .dark: return .purple
        case .light: return .orange
        }
    }
}


// MARK: - Preview
#Preview {
    SettingsMainView()
}
