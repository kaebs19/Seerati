//
//  TemplatePurchaseHelper.swift
//  Seerati
//
//  Path: Seerati/Features/Templates/Helpers/TemplatePurchaseHelper.swift
//

import SwiftUI

// MARK: - Template Purchase Strings
private enum TemplatePurchaseStrings {
    static var purchaseTemplate: String {
        LocalizationManager.shared.isArabic ? "شراء القالب" : "Purchase Template"
    }
    
    static var cancel: String {
        LocalizationManager.shared.isArabic ? "إلغاء" : "Cancel"
    }
    
    static var purchase: String {
        LocalizationManager.shared.isArabic ? "شراء" : "Purchase"
    }
    
    static var purchaseSuccess: String {
        LocalizationManager.shared.isArabic ? "تم الشراء بنجاح" : "Purchase Successful"
    }
    
    static var purchaseFailed: String {
        LocalizationManager.shared.isArabic ? "فشل الشراء" : "Purchase Failed"
    }
    
    static func purchaseMessage(_ name: String) -> String {
        LocalizationManager.shared.isArabic
            ? "هل تريد شراء قالب \(name)؟ أو يمكنك الترقية للنسخة المميزة للحصول على جميع القوالب."
            : "Would you like to purchase the \(name) template? Or upgrade to Premium for all templates."
    }
    
    static var upgradeToPremium: String {
        LocalizationManager.shared.isArabic ? "ترقية للمميز" : "Upgrade to Premium"
    }
}

// MARK: - Template Purchase Alert Modifier
struct TemplatePurchaseModifier: ViewModifier {
    
    @Binding var templateToPurchase: Template?
    @State private var showPremiumView = false
    
    func body(content: Content) -> some View {
        content
            .alert(
                TemplatePurchaseStrings.purchaseTemplate,
                isPresented: Binding(
                    get: { templateToPurchase != nil },
                    set: { if !$0 { templateToPurchase = nil } }
                ),
                presenting: templateToPurchase
            ) { template in
                Button(TemplatePurchaseStrings.cancel, role: .cancel) {
                    templateToPurchase = nil
                }
                
                Button(TemplatePurchaseStrings.upgradeToPremium) {
                    templateToPurchase = nil
                    showPremiumView = true
                }
            } message: { template in
                Text(TemplatePurchaseStrings.purchaseMessage(template.localizedName))
            }
            .sheet(isPresented: $showPremiumView) {
                PremiumView()
            }
    }
}

extension View {
    func templatePurchaseAlert(templateToPurchase: Binding<Template?>) -> some View {
        modifier(TemplatePurchaseModifier(templateToPurchase: templateToPurchase))
    }
}

// MARK: - Template Selection Handler
struct TemplateSelectionHandler {
    
    /// معالجة اختيار القالب
    static func handleSelection(
        _ template: Template,
        onFreeTemplate: () -> Void,
        onPurchasedTemplate: () -> Void,
        onNeedsPurchase: (Template) -> Void
    ) {
        let purchaseManager = PurchaseManager.shared
        
        // القالب المجاني
        if !template.isPremium {
            onFreeTemplate()
            return
        }
        
        // المستخدم Premium
        if purchaseManager.isPremium {
            onPurchasedTemplate()
            return
        }
        
        // تم شراء القالب سابقاً
        if purchaseManager.purchasedTemplates.contains(template.id) {
            onPurchasedTemplate()
            return
        }
        
        // يحتاج شراء أو ترقية
        onNeedsPurchase(template)
    }
}
