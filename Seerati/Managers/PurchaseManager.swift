//
//  PurchaseManager.swift
//  Seerati
//
//  Path: Seerati/Managers/PurchaseManager.swift
//
//  ─────────────────────────────────────────────
//  AR: إدارة المشتريات والاشتراكات
//  EN: Purchases and subscriptions management
//  ─────────────────────────────────────────────

import Foundation
import StoreKit

// MARK: - Product IDs
enum ProductID {
    static let premiumMonthly = "com.seerati.premium.monthly"
    static let premiumYearly = "com.seerati.premium.yearly"
    
    // Template IDs
    static let templateMonoFocus = "com.seerati.template.mono_focus"
    static let templateDarkSidebar = "com.seerati.template.dark_sidebar"
    static let templateExecutive = "com.seerati.template.executive"
    static let templateSerifClassic = "com.seerati.template.serif_classic"
    static let templateBoldType = "com.seerati.template.bold_type"
    static let templateSplitColumn = "com.seerati.template.split_column"
    static let templateModernist = "com.seerati.template.the_modernist"
    
    static func templateProductId(for templateId: String) -> String {
        return "com.seerati.template.\(templateId)"
    }
}

// MARK: - Purchase Manager
@Observable
final class PurchaseManager {
    
    // MARK: - Singleton
    static let shared = PurchaseManager()
    
    // MARK: - Properties
    
    /// هل المستخدم Premium؟
    var isPremium: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.isPremium) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isPremium) }
    }
    
    /// القوالب المشتراة
    var purchasedTemplates: Set<String> {
        get {
            let array = UserDefaults.standard.stringArray(forKey: Keys.purchasedTemplates) ?? []
            return Set(array)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: Keys.purchasedTemplates)
        }
    }
    
    /// عدد التصديرات هذا الشهر
    var exportsThisMonth: Int {
        get { UserDefaults.standard.integer(forKey: Keys.exportsThisMonth) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.exportsThisMonth) }
    }
    
    /// شهر آخر تصدير
    var lastExportMonth: Int {
        get { UserDefaults.standard.integer(forKey: Keys.lastExportMonth) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.lastExportMonth) }
    }
    
    /// الحد الأقصى للتصديرات الشهرية (مجاني)
    let freeExportLimit = 3
    
    /// سعر القالب
    let templatePrice = "9.99"
    
    /// سعر Premium الشهري
    let premiumMonthlyPrice = "19.99"
    
    /// سعر Premium السنوي
    let premiumYearlyPrice = "99.99"
    
    // MARK: - Keys
    private enum Keys {
        static let isPremium = "is_premium_user"
        static let purchasedTemplates = "purchased_templates"
        static let exportsThisMonth = "exports_this_month"
        static let lastExportMonth = "last_export_month"
    }
    
    // MARK: - Init
    private init() {
        checkMonthReset()
    }
    
    // MARK: - Template Access
    
    /// هل القالب متاح للمستخدم؟
    func isTemplateAvailable(_ templateId: String) -> Bool {
        // القالب المجاني
        if templateId == "swiss_minimal" {
            return true
        }
        
        // Premium يملك كل القوالب
        if isPremium {
            return true
        }
        
        // تحقق من الشراء الفردي
        return purchasedTemplates.contains(templateId)
    }
    
    /// شراء قالب
    func purchaseTemplate(_ templateId: String) async -> Bool {
        // TODO: تنفيذ StoreKit 2 الفعلي
        // حالياً نحاكي الشراء
        
        // محاكاة تأخير الشبكة
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // إضافة القالب للمشتريات
        var templates = purchasedTemplates
        templates.insert(templateId)
        purchasedTemplates = templates
        
        return true
    }
    
    /// شراء Premium
    func purchasePremium(yearly: Bool) async -> Bool {
        // TODO: تنفيذ StoreKit 2 الفعلي
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isPremium = true
        return true
    }
    
    /// استعادة المشتريات
    func restorePurchases() async -> Bool {
        // TODO: تنفيذ StoreKit 2 الفعلي
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    // MARK: - Export Limit
    
    /// هل يمكن التصدير؟
    var canExport: Bool {
        if isPremium { return true }
        checkMonthReset()
        return exportsThisMonth < freeExportLimit
    }
    
    /// التصديرات المتبقية
    var remainingExports: Int {
        if isPremium { return -1 } // غير محدود
        checkMonthReset()
        return max(0, freeExportLimit - exportsThisMonth)
    }
    
    /// تسجيل تصدير
    func recordExport() {
        guard !isPremium else { return }
        checkMonthReset()
        exportsThisMonth += 1
    }
    
    /// التحقق من إعادة تعيين الشهر
    private func checkMonthReset() {
        let currentMonth = Calendar.current.component(.month, from: Date())
        if lastExportMonth != currentMonth {
            exportsThisMonth = 0
            lastExportMonth = currentMonth
        }
    }
    
    // MARK: - Watermark
    
    /// هل يجب إضافة علامة مائية؟
    var shouldAddWatermark: Bool {
        return !isPremium
    }
    
    /// نص العلامة المائية
    let watermarkText = "Made with Seerati"
}

// MARK: - Template Extension
extension Template {
    /// هل القالب متاح للمستخدم الحالي؟
    var isAvailable: Bool {
        PurchaseManager.shared.isTemplateAvailable(id)
    }
    
    /// هل يحتاج شراء؟
    var needsPurchase: Bool {
        isPremium && !isAvailable
    }
}
