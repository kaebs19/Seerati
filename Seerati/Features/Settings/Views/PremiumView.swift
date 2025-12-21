//
//  PremiumView.swift
//  Seerati
//
//  Path: Seerati/Features/Premium/Views/PremiumView.swift
//
//  ─────────────────────────────────────────────────
//  AR: واجهة الاشتراك والترقية للنسخة المميزة
//  EN: Premium Subscription & Upgrade View
//  ─────────────────────────────────────────────────

import SwiftUI

// MARK: - Premium Strings
private enum PremiumStrings {
    static var title: String {
        LocalizationManager.shared.isArabic ? "النسخة المميزة" : "Premium"
    }
    
    static var unlockAll: String {
        LocalizationManager.shared.isArabic ? "افتح جميع المميزات" : "Unlock All Features"
    }
    
    static var subtitle: String {
        LocalizationManager.shared.isArabic
            ? "استمتع بتجربة كاملة بدون قيود"
            : "Enjoy the full experience without limits"
    }
    
    // Features
    static var feature1: String {
        LocalizationManager.shared.isArabic ? "جميع القوالب المميزة" : "All Premium Templates"
    }
    
    static var feature2: String {
        LocalizationManager.shared.isArabic ? "تصدير PDF غير محدود" : "Unlimited PDF Exports"
    }
    
    static var feature3: String {
        LocalizationManager.shared.isArabic ? "بدون علامة مائية" : "No Watermark"
    }
    
    static var feature4: String {
        LocalizationManager.shared.isArabic ? "دعم أولوية" : "Priority Support"
    }
    
    static var feature5: String {
        LocalizationManager.shared.isArabic ? "تحديثات مجانية" : "Free Updates"
    }
    
    static var feature6: String {
        LocalizationManager.shared.isArabic ? "ميزات حصرية قادمة" : "Exclusive Upcoming Features"
    }
    
    // Plans
    static var monthly: String {
        LocalizationManager.shared.isArabic ? "شهري" : "Monthly"
    }
    
    static var lifetime: String {
        LocalizationManager.shared.isArabic ? "مرة واحدة" : "Lifetime"
    }
    
    static var perMonth: String {
        LocalizationManager.shared.isArabic ? "/ شهر" : "/ month"
    }
    
    static var oneTime: String {
        LocalizationManager.shared.isArabic ? "دفعة واحدة" : "One-time"
    }
    
    static var bestValue: String {
        LocalizationManager.shared.isArabic ? "الأفضل قيمة" : "Best Value"
    }
    
    static var popular: String {
        LocalizationManager.shared.isArabic ? "الأكثر شعبية" : "Most Popular"
    }
    
    // Buttons
    static var subscribe: String {
        LocalizationManager.shared.isArabic ? "اشترك الآن" : "Subscribe Now"
    }
    
    static var purchase: String {
        LocalizationManager.shared.isArabic ? "شراء الآن" : "Purchase Now"
    }
    
    static var restore: String {
        LocalizationManager.shared.isArabic ? "استعادة المشتريات" : "Restore Purchases"
    }
    
    // Legal
    static var termsOfUse: String {
        LocalizationManager.shared.isArabic ? "شروط الاستخدام" : "Terms of Use"
    }
    
    static var privacyPolicy: String {
        LocalizationManager.shared.isArabic ? "سياسة الخصوصية" : "Privacy Policy"
    }
    
    static var contactUs: String {
        LocalizationManager.shared.isArabic ? "اتصل بنا" : "Contact Us"
    }
    
    // Apple Terms
    static var subscriptionTerms: String {
        LocalizationManager.shared.isArabic
            ? "سيتم تجديد الاشتراك تلقائياً ما لم يتم إلغاؤه قبل 24 ساعة من نهاية الفترة الحالية. يمكنك إدارة اشتراكاتك في إعدادات حسابك بعد الشراء."
            : "Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. You can manage subscriptions in your account settings after purchase."
    }
    
    // Alerts
    static var restoreSuccess: String {
        LocalizationManager.shared.isArabic ? "تم استعادة المشتريات بنجاح" : "Purchases restored successfully"
    }
    
    static var restoreError: String {
        LocalizationManager.shared.isArabic ? "لم يتم العثور على مشتريات سابقة" : "No previous purchases found"
    }
    
    static var purchaseSuccess: String {
        LocalizationManager.shared.isArabic ? "تم الشراء بنجاح! 🎉" : "Purchase successful! 🎉"
    }
    
    static var purchaseError: String {
        LocalizationManager.shared.isArabic ? "فشل الشراء" : "Purchase failed"
    }
    
    // Premium Active
    static var youArePremium: String {
        LocalizationManager.shared.isArabic ? "أنت مشترك مميز! 👑" : "You're Premium! 👑"
    }
    
    static var premiumActiveMessage: String {
        LocalizationManager.shared.isArabic
            ? "شكراً لدعمك! استمتع بجميع المميزات."
            : "Thanks for your support! Enjoy all features."
    }
}

// MARK: - Premium Plan Type
enum PremiumPlanType: String, CaseIterable, Identifiable {
    case monthly
    case lifetime
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .monthly: return PremiumStrings.monthly
        case .lifetime: return PremiumStrings.lifetime
        }
    }
    
    var badge: String? {
        switch self {
        case .monthly: return PremiumStrings.popular
        case .lifetime: return PremiumStrings.bestValue
        }
    }
    
    var periodText: String {
        switch self {
        case .monthly: return PremiumStrings.perMonth
        case .lifetime: return PremiumStrings.oneTime
        }
    }
    
    var icon: String {
        switch self {
        case .monthly: return "calendar"
        case .lifetime: return "infinity"
        }
    }
    
    var buttonText: String {
        switch self {
        case .monthly: return PremiumStrings.subscribe
        case .lifetime: return PremiumStrings.purchase
        }
    }
}

// MARK: - Premium View
struct PremiumView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PremiumPlanType = .lifetime
    @State private var isPurchasing = false
    @State private var isRestoring = false
    @State private var showSuccess = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Legal Sheets
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var showContact = false
    
    private let purchaseManager = PurchaseManager.shared
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                backgroundGradient
                
                if purchaseManager.isPremium {
                    // Premium Active View
                    premiumActiveView
                } else {
                    // Subscription View
                    subscriptionView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
        }
        .sheet(isPresented: $showTerms) {
            WebViewScreen(title: PremiumStrings.termsOfUse, url: AppURLs.termsOfUse)
        }
        .sheet(isPresented: $showPrivacy) {
            WebViewScreen(title: PremiumStrings.privacyPolicy, url: AppURLs.privacyPolicy)
        }
        .sheet(isPresented: $showContact) {
            WebViewScreen(title: PremiumStrings.contactUs, url: AppURLs.contactUs)
        }
        .alert(PremiumStrings.purchaseSuccess, isPresented: $showSuccess) {
            Button("OK") { dismiss() }
        }
        .alert(PremiumStrings.purchaseError, isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Background
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(hex: "1A1A2E"),
                Color(hex: "16213E"),
                Color(hex: "0F3460")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Subscription View
    private var subscriptionView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                headerSection
                    .padding(.top, 20)
                
                // Features
                featuresSection
                
                // Plans
                plansSection
                
                // Purchase Button
                purchaseButton
                
                // Restore
                restoreButton
                
                // Apple Terms
                appleTermsText
                
                // Legal Links
                legalLinks
                    .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Crown Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.yellow, Color.orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .yellow.opacity(0.5), radius: 20)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }
            
            // Title
            Text(PremiumStrings.unlockAll)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.white)
            
            // Subtitle
            Text(PremiumStrings.subtitle)
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(spacing: 12) {
            FeatureItemView(icon: "rectangle.stack.fill", text: PremiumStrings.feature1)
            FeatureItemView(icon: "arrow.down.doc.fill", text: PremiumStrings.feature2)
            FeatureItemView(icon: "xmark.circle.fill", text: PremiumStrings.feature3)
            FeatureItemView(icon: "headphones", text: PremiumStrings.feature4)
            FeatureItemView(icon: "arrow.triangle.2.circlepath", text: PremiumStrings.feature5)
            FeatureItemView(icon: "sparkles", text: PremiumStrings.feature6)
        }
        .padding(20)
        .background(.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Plans Section
    private var plansSection: some View {
        HStack(spacing: 12) {
            ForEach(PremiumPlanType.allCases) { plan in
                PlanCardView(
                    plan: plan,
                    price: getPlanPrice(plan),
                    isSelected: selectedPlan == plan
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedPlan = plan
                    }
                }
            }
        }
    }
    
    // MARK: - Purchase Button
    private var purchaseButton: some View {
        Button {
            Task {
                await purchasePlan()
            }
        } label: {
            HStack(spacing: 10) {
                if isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: selectedPlan == .monthly ? "creditcard.fill" : "bag.fill")
                        .font(.system(size: 18))
                    
                    Text(selectedPlan.buttonText)
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color.yellow, Color.orange],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .orange.opacity(0.4), radius: 10, y: 5)
        }
        .disabled(isPurchasing)
    }
    
    // MARK: - Restore Button
    private var restoreButton: some View {
        Button {
            Task {
                await restorePurchases()
            }
        } label: {
            HStack(spacing: 6) {
                if isRestoring {
                    ProgressView()
                        .tint(.white.opacity(0.8))
                        .scaleEffect(0.8)
                }
                Text(PremiumStrings.restore)
                    .font(.system(size: 14))
            }
            .foregroundStyle(.white.opacity(0.8))
        }
        .disabled(isRestoring)
    }
    
    // MARK: - Apple Terms
    private var appleTermsText: some View {
        Text(PremiumStrings.subscriptionTerms)
            .font(.system(size: 11))
            .foregroundStyle(.white.opacity(0.5))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 10)
    }
    
    // MARK: - Legal Links
    private var legalLinks: some View {
        HStack(spacing: 20) {
            Button(PremiumStrings.termsOfUse) {
                showTerms = true
            }
            
            Text("•")
            
            Button(PremiumStrings.privacyPolicy) {
                showPrivacy = true
            }
            
            Text("•")
            
            Button(PremiumStrings.contactUs) {
                showContact = true
            }
        }
        .font(.system(size: 12))
        .foregroundStyle(.white.opacity(0.6))
    }
    
    // MARK: - Premium Active View
    private var premiumActiveView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Crown
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.yellow, Color.orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: .yellow.opacity(0.5), radius: 30)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
            }
            
            // Text
            VStack(spacing: 10) {
                Text(PremiumStrings.youArePremium)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                
                Text(PremiumStrings.premiumActiveMessage)
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // Features List
            featuresSection
            
            Spacer()
            
            // Legal Links
            legalLinks
                .padding(.bottom, 30)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Methods
    private func getPlanPrice(_ plan: PremiumPlanType) -> String {
        switch plan {
        case .monthly:
            return purchaseManager.premiumMonthlyPrice
        case .lifetime:
            return purchaseManager.premiumLifetimePrice
        }
    }
    
    private func purchasePlan() async {
        isPurchasing = true
        
        let success: Bool
        switch selectedPlan {
        case .monthly:
            success = await purchaseManager.purchaseMonthly()
        case .lifetime:
            success = await purchaseManager.purchaseLifetime()
        }
        
        await MainActor.run {
            isPurchasing = false
            if success {
                showSuccess = true
            } else {
                errorMessage = LocalizationManager.shared.isArabic
                    ? "حدث خطأ أثناء الشراء. حاول مرة أخرى."
                    : "An error occurred during purchase. Please try again."
                showError = true
            }
        }
    }
    
    private func restorePurchases() async {
        isRestoring = true
        
        let success = await purchaseManager.restorePurchases()
        
        await MainActor.run {
            isRestoring = false
            if success {
                showSuccess = true
            } else {
                errorMessage = PremiumStrings.restoreError
                showError = true
            }
        }
    }
}

// MARK: - Feature Item View
private struct FeatureItemView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.yellow)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(.green)
        }
    }
}

// MARK: - Plan Card View
private struct PlanCardView: View {
    let plan: PremiumPlanType
    let price: String
    let isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                // Badge
                if let badge = plan.badge {
                    Text(badge)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(plan == .lifetime ? Color.orange : Color.blue)
                        .clipShape(Capsule())
                } else {
                    Spacer().frame(height: 20)
                }
                
                // Icon
                Image(systemName: plan.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(isSelected ? .yellow : .white.opacity(0.6))
                
                // Title
                Text(plan.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                
                // Price
                HStack(alignment: .bottom, spacing: 2) {
                    Text(price)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("ر.س")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.bottom, 3)
                }
                
                // Period
                Text(plan.periodText)
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .white.opacity(0.15) : .white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected
                            ? LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [.white.opacity(0.2)], startPoint: .top, endPoint: .bottom),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    PremiumView()
}
