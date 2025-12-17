//
//  TemplatePurchaseHelper.swift
//  Seerati
//
//  Path: Seerati/Features/Templates/Helpers/TemplatePurchaseHelper.swift
//
//  ─────────────────────────────────────────────
//  AR: مساعد شراء القوالب عند الضغط عليها
//  EN: Template purchase helper on tap
//  ─────────────────────────────────────────────

import SwiftUI

// MARK: - Template Purchase Alert Modifier
struct TemplatePurchaseModifier: ViewModifier {
    
    @Binding var templateToPurchase: Template?
    @State private var isPurchasing = false
    @State private var showSuccess = false
    @State private var showError = false
    
    func body(content: Content) -> some View {
        content
            .alert(
                SettingsStrings.purchaseTemplate,
                isPresented: Binding(
                    get: { templateToPurchase != nil },
                    set: { if !$0 { templateToPurchase = nil } }
                ),
                presenting: templateToPurchase
            ) { template in
                Button(SettingsStrings.cancel, role: .cancel) {
                    templateToPurchase = nil
                }
                
                Button(SettingsStrings.purchase) {
                    Task {
                        await purchaseTemplate(template)
                    }
                }
            } message: { template in
                Text(SettingsStrings.purchaseTemplateMessage(
                    template.localizedName,
                    price: "\(PurchaseManager.shared.templatePrice) ر.س"
                ))
            }
            .alert(SettingsStrings.purchaseSuccess, isPresented: $showSuccess) {
                Button("OK", role: .cancel) {}
            }
            .alert(SettingsStrings.purchaseFailed, isPresented: $showError) {
                Button("OK", role: .cancel) {}
            }
    }
    
    @MainActor
    private func purchaseTemplate(_ template: Template) async {
        isPurchasing = true
        let success = await PurchaseManager.shared.purchaseTemplate(template.id)
        isPurchasing = false
        
        if success {
            showSuccess = true
        } else {
            showError = true
        }
        templateToPurchase = nil
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
    /// - Parameters:
    ///   - template: القالب المختار
    ///   - onFreeTemplate: callback للقالب المجاني
    ///   - onPurchasedTemplate: callback للقالب المشترى
    ///   - onNeedsPurchase: callback للقالب الذي يحتاج شراء
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
        
        // يحتاج شراء
        onNeedsPurchase(template)
    }
}
