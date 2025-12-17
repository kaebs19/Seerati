//
//  SideMenuView.swift
//  Seerati
//
//  Path: Seerati/Features/SideMenu/Views/SideMenuView.swift
//
//  ─────────────────────────────────────────────
//  AR: القائمة الجانبية للتطبيق
//  EN: App side menu / drawer
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Side Menu View
struct SideMenuView: View {
    
    // MARK: - Properties
    @Binding var isPresented: Bool
    var onNavigate: (SideMenuDestination) -> Void
    
    @State private var showLanguageSheet = false
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .leading) {
            // Overlay
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isPresented = false
                        }
                    }
            }
            
            // Menu Content
            HStack(spacing: 0) {
                menuContent
                    .frame(width: 280)
                    .background(AppColors.background)
                    .offset(x: isPresented ? 0 : -280)
                
                Spacer()
            }
        }
        .allowsHitTesting(isPresented) // ✅ Fix: Allow touches to pass through when hidden
        .animation(.easeInOut(duration: 0.25), value: isPresented)
        .sheet(isPresented: $showLanguageSheet) {
            LanguagePickerSheet()
        }
    }
    
    // MARK: - Menu Content
    private var menuContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            menuHeader
            
            // Menu Items
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    // Main Section
                    mainSection
                    
                    menuDivider
                    
                    // Support Section
                    supportSection
                    
                    menuDivider
                    
                    // Other Section
                    otherSection
                }
                .padding(.vertical, AppSpacing.md)
            }
            
            // Footer
            menuFooter
        }
    }
    
    // MARK: - Header
    private var menuHeader: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Close Button
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(width: 40, height: 40)
                }
            }
            
            // User Info
            HStack(spacing: AppSpacing.sm) {
                // Avatar
                Circle()
                    .fill(AppColors.primary.opacity(0.2))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(AppColors.primary)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(UserDefaultsManager.shared.userName ?? "Guest")
                        .font(AppFonts.title3())
                        .foregroundStyle(AppColors.textPrimary)
                    
                    if let email = UserDefaultsManager.shared.userEmail {
                        Text(email)
                            .font(AppFonts.caption())
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
            .padding(.bottom, AppSpacing.md)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.lg)
        .background(AppColors.surface)
    }
    
    // MARK: - Main Section
    private var mainSection: some View {
        VStack(spacing: 0) {
            MenuItem(
                icon: "person.fill",
                title: SideMenuStrings.profile
            ) {
                navigate(to: .profile)
            }
            
            MenuItem(
                icon: "doc.text.fill",
                title: SideMenuStrings.myCVs
            ) {
                navigate(to: .myCVs)
            }
            
            MenuItem(
                icon: "square.grid.2x2.fill",
                title: SideMenuStrings.templates
            ) {
                navigate(to: .templates)
            }
            
            MenuItem(
                icon: "gearshape.fill",
                title: SideMenuStrings.settings
            ) {
                navigate(to: .settings)
            }
        }
    }
    
    // MARK: - Support Section
    private var supportSection: some View {
        VStack(spacing: 0) {
            MenuItem(
                icon: "shield.fill",
                title: SideMenuStrings.privacyPolicy
            ) {
                navigate(to: .privacyPolicy)
            }
            
            MenuItem(
                icon: "doc.plaintext.fill",
                title: SideMenuStrings.termsOfUse
            ) {
                navigate(to: .termsOfUse)
            }
            
            MenuItem(
                icon: "envelope.fill",
                title: SideMenuStrings.contactUs
            ) {
                navigate(to: .contactUs)
            }
            
            MenuItem(
                icon: "info.circle.fill",
                title: SideMenuStrings.aboutApp
            ) {
                navigate(to: .about)
            }
        }
    }
    
    // MARK: - Other Section
    private var otherSection: some View {
        VStack(spacing: 0) {
            MenuItem(
                icon: "star.fill",
                title: SideMenuStrings.rateApp
            ) {
                navigate(to: .rateApp)
            }
            
            MenuItem(
                icon: "square.and.arrow.up.fill",
                title: SideMenuStrings.shareApp
            ) {
                navigate(to: .shareApp)
            }
            
            MenuItem(
                icon: "globe",
                title: SideMenuStrings.language,
                trailing: currentLanguageText
            ) {
                showLanguageSheet = true
            }
        }
    }
    
    // MARK: - Footer
    private var menuFooter: some View {
        VStack(spacing: AppSpacing.xs) {
            Divider()
                .background(AppColors.border)
            
            Text("\(SideMenuStrings.version) \(appVersion)")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
                .padding(.vertical, AppSpacing.md)
        }
    }
    
    // MARK: - Helpers
    private var menuDivider: some View {
        Divider()
            .background(AppColors.border)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.sm)
    }
    
    private var currentLanguageText: String {
        LocalizationManager.shared.isArabic ? "العربية" : "English"
    }
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private func navigate(to destination: SideMenuDestination) {
        withAnimation {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onNavigate(destination)
        }
    }
}

// MARK: - Menu Item
struct MenuItem: View {
    
    let icon: String
    let title: String
    var trailing: String? = nil
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
                
                if let trailing = trailing {
                    Text(trailing)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Side Menu Destination
enum SideMenuDestination {
    case profile
    case myCVs
    case templates
    case settings
    case privacyPolicy
    case termsOfUse
    case contactUs
    case about
    case rateApp
    case shareApp
}

// MARK: - Language Picker Sheet
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
            .navigationTitle(SideMenuStrings.language)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.height(200)])
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.gray
        SideMenuView(isPresented: .constant(true)) { destination in
            print("Navigate to: \(destination)")
        }
    }
}
