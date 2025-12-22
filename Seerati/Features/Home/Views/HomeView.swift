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
    
    @State private var shouldOpenCreateCV = false
    
    // ✅ واجهة Premium
    @State private var showPremiumView = false
    
    // ✅ معاينة القالب
    @State private var selectedTemplateForPreview: Template?
    
    // ✅ حالة البانر
    @State private var isBannerLoaded = false
    
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
            NavigationStack {
                PersonalInfoMainView(cv: cv)
            }
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
            SettingsMainView()
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
        // ✅ واجهة Premium
        .sheet(isPresented: $showPremiumView) {
            PremiumView()
        }
        // ✅ معاينة القالب
        .sheet(item: $selectedTemplateForPreview) { template in
            TemplatePreviewSheet(template: template)
        }
        
        .onChange(of: selectedTemplateForPreview) { oldValue, newValue in
            // ✅ عندما يتم إغلاق الـ sheet (newValue = nil) وكان هناك قالب مختار
            if newValue == nil && oldValue != nil {
                // تحقق إذا تم اختيار القالب (محفوظ في UserDefaults)
                if let savedId = UserDefaults.standard.string(forKey: "selectedTemplateId"),
                   savedId == oldValue?.id {
                    // افتح إنشاء CV بعد تأخير قصير
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showCreateCV = true
                    }
                }
            }
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
            Button(CommonStrings.cancel, role: .cancel) {}
        }
        .alert(HomeStrings.delete + "?", isPresented: $viewModel.showDeleteConfirmation) {
            Button(CommonStrings.cancel, role: .cancel) {}
            Button(CommonStrings.delete, role: .destructive) {
                viewModel.deleteCV()
            }
        } message: {
            Text(MyCVsStrings.deleteMessage)
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    // Header
                    headerSection
                    
                    // Create Button
                    CreateCVButton {
                        // ✅ عرض إعلان بيني قبل إنشاء CV
                        AdMobManager.shared.showInterstitial {
                            showCreateCV = true
                        }
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
            
            // ✅ Banner Ad في الأسفل
            bannerAdSection
        }
    }
    
    // ✅ MARK: - Banner Ad Section
    private var bannerAdSection: some View {
        Group {
            if !PurchaseManager.shared.isPremium {
                AdaptiveBannerAdView(isLoaded: $isBannerLoaded)
                    .frame(height: isBannerLoaded ? 50 : 0)
                    .animation(.easeInOut(duration: 0.3), value: isBannerLoaded)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
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
            
            Text(LocalizationManager.shared.isArabic ? "سيرتي" : "Seerati")
                .font(AppFonts.title2())
                .foregroundStyle(AppColors.primary)
            
            Spacer()
            
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
                handleTemplateSelection(template)
            }
        }
    }
    
    // ✅ MARK: - Handle Template Selection
    private func handleTemplateSelection(_ template: Template) {
        // ✅ عرض إعلان بيني أولاً
        AdMobManager.shared.showInterstitial {
            if template.isPremium && !PurchaseManager.shared.isPremium {
                // القالب مدفوع - اعرض Premium
                showPremiumView = true
            } else {
                // القالب متاح - افتح المعاينة
                selectedTemplateForPreview = template
            }
        }
    }
    
    // MARK: - Recent CVs Section
    private var recentCVsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: HomeStrings.recentCVs)
                .padding(.horizontal, AppSpacing.screenHorizontal)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.xxl)
            } else if viewModel.recentCVs.isEmpty {
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
            AppActions.shared.rateApp()
        case .shareApp:
            AppActions.shared.shareApp()
        }
    }
}
