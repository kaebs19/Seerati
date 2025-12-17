//
//  PremiumCard.swift
//  Seerati
//
//  Path: Seerati/Features/Settings/Components/PremiumCard.swift
//
//  ─────────────────────────────────────────────
//  AR: بطاقة الترقية إلى النسخة المميزة
//  EN: Premium upgrade promotion card
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Premium Card
struct PremiumCard: View {
    
    // MARK: - Properties
    var isPremium: Bool
    var onUpgrade: () -> Void
    
    // MARK: - Body
    var body: some View {
        if isPremium {
            premiumActiveCard
        } else {
            upgradeCard
        }
    }
    
    // MARK: - Upgrade Card
    private var upgradeCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Header
            HStack {
                Image(systemName: "crown.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.yellow)
                
                Text(SettingsStrings.upgradeToPremium)
                    .font(AppFonts.title3())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            // Features
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                FeatureRow(icon: "checkmark", text: SettingsStrings.premiumFeature1)
                FeatureRow(icon: "checkmark", text: SettingsStrings.premiumFeature2)
                FeatureRow(icon: "checkmark", text: SettingsStrings.premiumFeature3)
            }
            
            // Button
            Button(action: onUpgrade) {
                Text(SettingsStrings.viewPlans)
                    .font(AppFonts.button())
                    .foregroundStyle(AppColors.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            }
        }
        .padding(AppSpacing.lg)
        .background(
            LinearGradient(
                colors: [
                    AppColors.primary,
                    AppColors.primary.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusLarge))
    }
    
    // MARK: - Premium Active Card
    private var premiumActiveCard: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "crown.fill")
                .font(.system(size: 28))
                .foregroundStyle(.yellow)
            
            Text(SettingsStrings.youArePremium)
                .font(AppFonts.body(weight: .semibold))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(AppSpacing.lg)
        .background(AppColors.primary)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusLarge))
    }
}

// MARK: - Feature Row
private struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white.opacity(0.9))
            
            Text(text)
                .font(AppFonts.subheadline())
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}

// MARK: - Premium Plans Sheet
struct PremiumPlansSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PremiumPlan = .yearly
    @State private var isPurchasing = false
    
    var onPurchase: (Bool) async -> Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                // Header
                VStack(spacing: AppSpacing.sm) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.yellow)
                    
                    Text(SettingsStrings.upgradeToPremium)
                        .font(AppFonts.title())
                        .foregroundStyle(AppColors.textPrimary)
                }
                .padding(.top, AppSpacing.xl)
                
                // Features
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    PremiumFeatureItem(icon: "square.grid.2x2.fill", text: SettingsStrings.premiumFeature1)
                    PremiumFeatureItem(icon: "arrow.down.doc.fill", text: SettingsStrings.premiumFeature2)
                    PremiumFeatureItem(icon: "xmark.circle.fill", text: SettingsStrings.premiumFeature3)
                }
                .padding(.horizontal, AppSpacing.lg)
                
                // Plans
                HStack(spacing: AppSpacing.md) {
                    PlanCard(
                        plan: .monthly,
                        isSelected: selectedPlan == .monthly
                    ) {
                        selectedPlan = .monthly
                    }
                    
                    PlanCard(
                        plan: .yearly,
                        isSelected: selectedPlan == .yearly
                    ) {
                        selectedPlan = .yearly
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                
                Spacer()
                
                // Subscribe Button
                PrimaryButton(
                    SettingsStrings.subscribe,
                    isLoading: isPurchasing
                ) {
                    Task {
                        isPurchasing = true
                        let success = await onPurchase(selectedPlan == .yearly)
                        isPurchasing = false
                        if success {
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
            .background(AppColors.background)
            .navigationTitle(SettingsStrings.choosePlan)
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
}

// MARK: - Premium Plan
enum PremiumPlan {
    case monthly
    case yearly
    
    var title: String {
        switch self {
        case .monthly: return SettingsStrings.monthly
        case .yearly: return SettingsStrings.yearly
        }
    }
    
    var price: String {
        switch self {
        case .monthly: return PurchaseManager.shared.premiumMonthlyPrice
        case .yearly: return PurchaseManager.shared.premiumYearlyPrice
        }
    }
    
    var period: String {
        switch self {
        case .monthly: return SettingsStrings.perMonth
        case .yearly: return SettingsStrings.perYear
        }
    }
    
    var badge: String? {
        switch self {
        case .monthly: return nil
        case .yearly: return SettingsStrings.save40
        }
    }
}

// MARK: - Plan Card
private struct PlanCard: View {
    let plan: PremiumPlan
    let isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: AppSpacing.sm) {
                // Badge
                if let badge = plan.badge {
                    Text(badge)
                        .font(AppFonts.caption2(weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.warning)
                        .clipShape(Capsule())
                } else {
                    Spacer()
                        .frame(height: 20)
                }
                
                Text(plan.title)
                    .font(AppFonts.subheadline(weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text(plan.price)
                        .font(AppFonts.title2())
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text("ر.س")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Text(plan.period)
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.lg)
            .background(isSelected ? AppColors.primary.opacity(0.1) : AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusMedium))
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.radiusMedium)
                    .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Premium Feature Item
private struct PremiumFeatureItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(AppColors.primary)
                .frame(width: 32)
            
            Text(text)
                .font(AppFonts.body())
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        PremiumCard(isPremium: false) {
            print("Upgrade tapped")
        }
        
        PremiumCard(isPremium: true) {}
    }
    .padding()
    .background(AppColors.background)
}
