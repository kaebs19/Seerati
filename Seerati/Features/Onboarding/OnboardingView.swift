//
//  OnboardingView.swift
//  Seerati
//
//  Path: Seerati/Features/Onboarding/Views/OnboardingView.swift
//

import SwiftUI
import Lottie

// MARK: - Onboarding Strings
private enum OnboardingStrings {
    static var skip: String {
        LocalizationManager.shared.isArabic ? "تخطي" : "Skip"
    }
    
    static var next: String {
        LocalizationManager.shared.isArabic ? "التالي" : "Next"
    }
    
    static var getStarted: String {
        LocalizationManager.shared.isArabic ? "ابدأ الآن" : "Get Started"
    }
    
    // Page 1
    static var title1: String {
        LocalizationManager.shared.isArabic ? "أنشئ سيرتك الذاتية" : "Create Your CV"
    }
    
    static var subtitle1: String {
        LocalizationManager.shared.isArabic
            ? "صمم سيرة ذاتية احترافية في دقائق معدودة"
            : "Design a professional CV in just minutes"
    }
    
    // Page 2
    static var title2: String {
        LocalizationManager.shared.isArabic ? "قوالب احترافية" : "Professional Templates"
    }
    
    static var subtitle2: String {
        LocalizationManager.shared.isArabic
            ? "اختر من بين مجموعة متنوعة من القوالب الجاهزة"
            : "Choose from a variety of ready-made templates"
    }
    
    // Page 3
    static var title3: String {
        LocalizationManager.shared.isArabic ? "صدّر وشارك" : "Export & Share"
    }
    
    static var subtitle3: String {
        LocalizationManager.shared.isArabic
            ? "صدّر سيرتك بصيغة PDF وشاركها بسهولة"
            : "Export your CV as PDF and share it easily"
    }
    
    // Language
    static var selectLanguage: String {
        LocalizationManager.shared.isArabic ? "اختر اللغة" : "Select Language"
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
}

// MARK: - Onboarding View
struct OnboardingView: View {
    
    // MARK: - Properties
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    @State private var selectedLanguage: Language = LocalizationManager.shared.currentLanguage
    
    private var pages: [OnboardingPage] {
        [
            OnboardingPage(
                icon: "doc.text.fill",
                title: OnboardingStrings.title1,
                subtitle: OnboardingStrings.subtitle1,
                color: AppColors.primary
            ),
            OnboardingPage(
                icon: "rectangle.stack.fill",
                title: OnboardingStrings.title2,
                subtitle: OnboardingStrings.subtitle2,
                color: Color.orange
            ),
            OnboardingPage(
                icon: "square.and.arrow.up.fill",
                title: OnboardingStrings.title3,
                subtitle: OnboardingStrings.subtitle3,
                color: Color.green
            )
        ]
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                topBar
                
                // Content
                TabView(selection: $currentPage) {
                    // ✅ صفحة اللغة أولاً
                    languageSelectionPage
                        .tag(0)
                    
                    // باقي الصفحات
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingPageView(page: page, showAnimation: index == 0)
                            .tag(index + 1)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Page Indicator
                pageIndicator
                
                // Button
                actionButton
            }
        }
        .environment(\.layoutDirection, selectedLanguage == .arabic ? .rightToLeft : .leftToRight)
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Spacer()
            
            if currentPage < pages.count {
                Button(OnboardingStrings.skip) {
                    completeOnboarding()
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
                .padding()
            }
        }
    }
    
    // ✅ MARK: - Language Selection Page
    private var languageSelectionPage: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.15))
                    .frame(width: 150, height: 150)
                
                Image(systemName: "globe")
                    .font(.system(size: 60))
                    .foregroundStyle(AppColors.primary)
            }
            
            // Title
            VStack(spacing: 16) {
                Text(OnboardingStrings.selectLanguage)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
            }
            
            // Language Options
            VStack(spacing: 12) {
                LanguageOptionButton(
                    language: .arabic,
                    isSelected: selectedLanguage == .arabic
                ) {
                    selectLanguage(.arabic)
                }
                
                LanguageOptionButton(
                    language: .english,
                    isSelected: selectedLanguage == .english
                ) {
                    selectLanguage(.english)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
    
    // MARK: - Page Indicator
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<(pages.count + 1), id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? AppColors.primary : AppColors.primary.opacity(0.3))
                    .frame(width: currentPage == index ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3), value: currentPage)
            }
        }
        .padding(.bottom, 30)
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Button {
            if currentPage < pages.count {
                withAnimation {
                    currentPage += 1
                }
            } else {
                completeOnboarding()
            }
        } label: {
            Text(currentPage < pages.count ? OnboardingStrings.next : OnboardingStrings.getStarted)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColors.primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
    
    // MARK: - Methods
    private func selectLanguage(_ language: Language) {
        withAnimation {
            selectedLanguage = language
            LocalizationManager.shared.setLanguage(language)
        }
    }
    
    private func completeOnboarding() {
        withAnimation {
            hasCompletedOnboarding = true
        }
    }
}

// MARK: - Language Option Button
struct LanguageOptionButton: View {
    let language: Language
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Flag/Icon
                Text(language == .arabic ? "🇸🇦" : "🇺🇸")
                    .font(.system(size: 32))
                
                // Language Name
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.nativeName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text(language == .arabic ? "Arabic" : "English")
                        .font(.system(size: 14))
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
                
                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(AppColors.primary)
                }
            }
            .padding(16)
            .background(isSelected ? AppColors.primary.opacity(0.1) : AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPage
    var showAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            if showAnimation {
                LottieView(animationName: "jous")
                    .frame(width: 280, height: 280)
            } else {
                ZStack {
                    Circle()
                        .fill(page.color.opacity(0.15))
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .fill(page.color.opacity(0.1))
                        .frame(width: 160, height: 160)
                    
                    Image(systemName: page.icon)
                        .font(.system(size: 70))
                        .foregroundStyle(page.color)
                }
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.system(size: 17))
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Lottie View
struct LottieView: UIViewRepresentable {
    let animationName: String
    var loopMode: LottieLoopMode = .loop
    var animationSpeed: CGFloat = 1.0
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
