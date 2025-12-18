//
//  SideMenuView.swift
//  Seerati
//
//  Path: Seerati/Features/SideMenu/Views/SideMenuView.swift
//
//  ─────────────────────────────────────────────────
//  AR: القائمة الجانبية للتطبيق - محدثة
//  EN: App side menu / drawer - Updated
//  ─────────────────────────────────────────────────

import SwiftUI

// MARK: - Side Menu View
struct SideMenuView: View {
    
    // MARK: - Properties
    @Binding var isPresented: Bool
    var onNavigate: (SideMenuDestination) -> Void
    
    @State private var showLanguageSheet = false
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfUse = false
    @State private var showContactUs = false
    @State private var showAbout = false
    
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
        .allowsHitTesting(isPresented)
        .animation(.easeInOut(duration: 0.25), value: isPresented)
        // Sheets
        .sheet(isPresented: $showLanguageSheet) {
            LanguagePickerSheet()
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            WebViewScreen(title: SideMenuStrings.privacyPolicy, url: AppURLs.privacyPolicy)
        }
        .sheet(isPresented: $showTermsOfUse) {
            WebViewScreen(title: SideMenuStrings.termsOfUse, url: AppURLs.termsOfUse)
        }
        .sheet(isPresented: $showContactUs) {
            WebViewScreen(title: SideMenuStrings.contactUs, url: AppURLs.contactUs)
        }
        .sheet(isPresented: $showAbout) {
            AboutAppSheet()
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
                if let imageData = UserDefaults.standard.data(forKey: "defaultProfileImage"),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(AppColors.primary.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(AppColors.primary)
                        )
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(userName)
                        .font(AppFonts.title3())
                        .foregroundStyle(AppColors.textPrimary)
                    
                    if !userEmail.isEmpty {
                        Text(userEmail)
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
                closeAndShow { showPrivacyPolicy = true }
            }
            
            MenuItem(
                icon: "doc.plaintext.fill",
                title: SideMenuStrings.termsOfUse
            ) {
                closeAndShow { showTermsOfUse = true }
            }
            
            MenuItem(
                icon: "envelope.fill",
                title: SideMenuStrings.contactUs
            ) {
                closeAndShow { showContactUs = true }
            }
            
            MenuItem(
                icon: "info.circle.fill",
                title: SideMenuStrings.aboutApp
            ) {
                closeAndShow { showAbout = true }
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
                withAnimation { isPresented = false }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    AppActions.shared.rateApp()
                }
            }
            
            MenuItem(
                icon: "square.and.arrow.up.fill",
                title: SideMenuStrings.shareApp
            ) {
                withAnimation { isPresented = false }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    AppActions.shared.shareApp()
                }
            }
            
            MenuItem(
                icon: "globe",
                title: SideMenuStrings.language,
                trailing: currentLanguageText
            ) {
                closeAndShow { showLanguageSheet = true }
            }
        }
    }
    
    // MARK: - Footer
    private var menuFooter: some View {
        VStack(spacing: AppSpacing.xs) {
            Divider()
                .background(AppColors.border)
            
            Text("\(SideMenuStrings.version) \(AppActions.shared.fullVersion)")
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
    
    private var userName: String {
        UserDefaults.standard.string(forKey: "defaultFullName") ?? "ضيف"
    }
    
    private var userEmail: String {
        UserDefaults.standard.string(forKey: "defaultEmail") ?? ""
    }
    
    private func navigate(to destination: SideMenuDestination) {
        withAnimation {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onNavigate(destination)
        }
    }
    
    private func closeAndShow(action: @escaping () -> Void) {
        withAnimation {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            action()
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
                    Button("تم") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.height(200)])
    }
}

// MARK: - About App Sheet
struct AboutAppSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // App Icon
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(AppColors.primary)
                        .padding(.top, AppSpacing.xl)
                    
                    // App Name
                    VStack(spacing: AppSpacing.xs) {
                        Text("سيرتي")
                            .font(.system(size: 28, weight: .bold))
                        
                        Text("Seerati")
                            .font(.system(size: 18))
                            .foregroundStyle(AppColors.textSecondary)
                        
                        Text("الإصدار \(AppActions.shared.fullVersion)")
                            .font(AppFonts.caption())
                            .foregroundStyle(AppColors.textSecondary)
                            .padding(.top, AppSpacing.xs)
                    }
                    
                    // Description
                    Text("تطبيق سيرتي هو أفضل تطبيق لإنشاء السير الذاتية الاحترافية باللغة العربية والإنجليزية. صمم سيرتك الذاتية بسهولة واحترافية.")
                        .font(AppFonts.body())
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                    
                    // Features
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        featureRow(icon: "paintpalette.fill", text: "قوالب احترافية متعددة")
                        featureRow(icon: "globe", text: "دعم العربية والإنجليزية")
                        featureRow(icon: "doc.fill", text: "تصدير PDF عالي الجودة")
                        featureRow(icon: "lock.fill", text: "خصوصية تامة - بياناتك على جهازك")
                    }
                    .padding(AppSpacing.lg)
                    .background(AppColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, AppSpacing.screenHorizontal)
                    
                    // Social Links
                    HStack(spacing: AppSpacing.xl) {
                        socialButton(icon: "star.fill", label: "قيّمنا") {
                            AppActions.shared.openAppStoreReview()
                        }
                        
                        socialButton(icon: "square.and.arrow.up", label: "شارك") {
                            AppActions.shared.shareApp()
                        }
                        
                        socialButton(icon: "envelope.fill", label: "تواصل") {
                            AppActions.shared.contactSupport()
                        }
                    }
                    .padding(.top, AppSpacing.md)
                    
                    Spacer(minLength: 50)
                    
                    // Copyright
                    Text("© 2024 سيرتي. جميع الحقوق محفوظة.")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                        .padding(.bottom, AppSpacing.xl)
                }
            }
            .background(AppColors.background)
            .navigationTitle("عن التطبيق")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
        }
    }
    
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(AppColors.primary)
                .frame(width: 24)
            
            Text(text)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
        }
    }
    
    private func socialButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(AppColors.primary)
                
                Text(label)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
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
