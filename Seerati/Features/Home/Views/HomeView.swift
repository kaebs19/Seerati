//
//  HomeView.swift
//  Seerati
//
//  Path: Seerati/Features/Home/Views/HomeView.swift
//
//  ─────────────────────────────────────────────
//  AR: الشاشة الرئيسية للتطبيق - عرض السير الذاتية
//  EN: Main home screen - displays CVs list
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Home View
struct HomeView: View {
    
    // MARK: - Properties
    @State private var viewModel = HomeViewModel()
    @State private var showCreateCV = false
    @State private var showSideMenu = false
    @State private var selectedCVForEdit: CVData?
    
    // Navigation States
    @State private var showProfile = false
    @State private var showMyCVs = false
    @State private var showTemplates = false
    @State private var showSettings = false
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfUse = false
    @State private var showContactUs = false
    @State private var showAbout = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Main Content
                mainContent
                
                // Side Menu Overlay
                SideMenuView(isPresented: $showSideMenu) { destination in
                    handleNavigation(destination)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showCreateCV) {
            CreateCVFlowView()
        }
        .sheet(item: $selectedCVForEdit) { cv in
            PersonalInfoMainView(cv: cv)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showMyCVs) {
            MyCVsView()
        }
        .sheet(isPresented: $showTemplates) {
            TemplatesView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showTermsOfUse) {
            TermsOfUseView()
        }
        .sheet(isPresented: $showContactUs) {
            ContactUsView()
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .confirmationDialog(
            "CV Options",
            isPresented: $viewModel.showActionSheet,
            presenting: viewModel.selectedCV
        ) { cv in
            Button(HomeStrings.edit) {
                selectedCVForEdit = cv
            }
            Button(HomeStrings.duplicate) {
                viewModel.duplicateCV(cv)
            }
            Button(HomeStrings.share) {
                viewModel.shareCV(cv)
            }
            Button(HomeStrings.delete, role: .destructive) {
                viewModel.confirmDelete(cv)
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Delete CV?", isPresented: $viewModel.showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteCV()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                // Header
                headerSection
                
                // Create Button
                CreateCVButton {
                    showCreateCV = true
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                
                // Templates
                templatesSection
                
                // Recent CVs
                recentCVsSection
            }
            .padding(.vertical, AppSpacing.screenTop)
        }
        .background(AppColors.background)
        .refreshable {
            viewModel.refresh()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            // Menu Button
            Button {
                withAnimation {
                    showSideMenu = true
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            // App Logo/Title
            Text("Seerati")
                .font(AppFonts.title2())
                .foregroundStyle(AppColors.primary)
            
            Spacer()
            
            // Settings Button
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal - 8)
    }
    
    // MARK: - Templates Section
    private var templatesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(
                title: HomeStrings.templates,
                actionTitle: HomeStrings.viewAll
            ) {
                showTemplates = true
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            
            TemplateCarousel(templates: Template.allTemplates) { template in
                // Handle template selection
                if template.isPremium {
                    // Show premium prompt
                    print("Premium template: \(template.name)")
                } else {
                    // Use free template
                    print("Free template: \(template.name)")
                }
            }
        }
    }
    
    // MARK: - Recent CVs Section
    private var recentCVsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: HomeStrings.recentCVs)
                .padding(.horizontal, AppSpacing.screenHorizontal)
            
            if viewModel.isLoading {
                // Loading State
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.xxl)
            } else if viewModel.recentCVs.isEmpty {
                // Empty State
                EmptyStateCard(
                    icon: "doc.text",
                    title: HomeStrings.noCVsYet,
                    message: HomeStrings.createFirstCV,
                    buttonTitle: HomeStrings.createNewCV
                ) {
                    showCreateCV = true
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
            } else {
                // CVs List
                RecentCVsList(
                    cvs: viewModel.recentCVs,
                    onSelect: { cv in
                        selectedCVForEdit = cv
                    },
                    onMenu: { cv in
                        viewModel.selectCV(cv)
                    }
                )
                .padding(.horizontal, AppSpacing.screenHorizontal)
            }
        }
    }
    
    // MARK: - Navigation Handler
    private func handleNavigation(_ destination: SideMenuDestination) {
        switch destination {
        case .profile:
            showProfile = true
        case .myCVs:
            showMyCVs = true
        case .templates:
            showTemplates = true
        case .settings:
            showSettings = true
        case .privacyPolicy:
            showPrivacyPolicy = true
        case .termsOfUse:
            showTermsOfUse = true
        case .contactUs:
            showContactUs = true
        case .about:
            showAbout = true
        case .rateApp:
            rateApp()
        case .shareApp:
            shareApp()
        }
    }
    
    // MARK: - Actions
    private func rateApp() {
        // Open App Store for rating
        if let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareApp() {
        let text = "Check out Seerati - Create professional CVs easily!"
        let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")!
        let activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Placeholder Views
struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Text("Profile View")
                .navigationTitle(SideMenuStrings.profile)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct MyCVsView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Text("My CVs View")
                .navigationTitle(SideMenuStrings.myCVs)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct TemplatesView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Text("Templates View")
                .navigationTitle(SideMenuStrings.templates)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

// Note: SettingsMainView moved to Features/Settings/Views/SettingsView.swift

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Text("Privacy Policy")
                .navigationTitle(SideMenuStrings.privacyPolicy)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct TermsOfUseView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Text("Terms of Use")
                .navigationTitle(SideMenuStrings.termsOfUse)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct ContactUsView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Text("Contact Us")
                .navigationTitle(SideMenuStrings.contactUs)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Text("About App")
                .navigationTitle(SideMenuStrings.aboutApp)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
