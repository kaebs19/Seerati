//
//  PurchaseManager.swift
//  Seerati
//
//  Path: Seerati/Managers/PurchaseManager.swift
//
//  ─────────────────────────────────────────────────
//  AR: مدير المشتريات داخل التطبيق - محدث
//  EN: In-App Purchases Manager - Updated
//  ─────────────────────────────────────────────────

import Foundation
import StoreKit

// MARK: - Product IDs
enum ProductID {
    // ✅ الاشتراكات
    static let premiumMonthly = "com.seerati.premium.monthly"
    static let premiumYearly = "com.seerati.premium.yearly"
    
    // ✅ Lifetime (Non-Consumable)
    static let premiumLifetime = "com.seerati.premium.lifetime"
    
    // القوالب (Non-Consumable)
    static let templateDarkSidebar = "com.seerati.template.darksidebar"
    static let templateExecutive = "com.seerati.template.executive"
    static let templateModernist = "com.seerati.template.modernist"
}

// MARK: - Purchase Manager
@Observable
@MainActor
final class PurchaseManager {
    
    // MARK: - Singleton
    static let shared = PurchaseManager()
    
    // MARK: - Properties
    
    /// هل المستخدم Premium؟
    private(set) var isPremium: Bool = false
    
    /// نوع الاشتراك الحالي
    private(set) var subscriptionType: SubscriptionType = .none
    
    /// القوالب المشتراة
    private(set) var purchasedTemplates: Set<String> = []
    
    /// عدد التصديرات المتبقية للمستخدم المجاني
    private(set) var remainingExports: Int = 3
    
    /// الحد الأقصى للتصديرات المجانية
    let freeExportLimit: Int = 3
    
    // MARK: - Products
    private var products: [Product] = []
    
    // MARK: - Prices (للعرض)
    var premiumMonthlyPrice: String = "9.99"
    var premiumYearlyPrice: String = "49.99"
    var premiumLifetimePrice: String = "99.99"
    
    // MARK: - Init
    private init() {
        // تحميل الحالة المحفوظة
        loadSavedState()
        
        // بدء مراقبة المعاملات
        Task {
            await loadProducts()
            await updatePurchaseStatus()
            await listenForTransactions()
        }
    }
    
    // MARK: - Computed Properties
    
    /// هل يمكن التصدير؟
    var canExport: Bool {
        isPremium || remainingExports > 0
    }
    
    /// هل يجب إضافة علامة مائية؟
    var shouldAddWatermark: Bool {
        !isPremium
    }
    
    /// نص العلامة المائية
    var watermarkText: String {
        "Made with Seerati"
    }
    
    // MARK: - Load Products
    func loadProducts() async {
        do {
            let productIDs = [
                ProductID.premiumMonthly,
                ProductID.premiumYearly,
                ProductID.premiumLifetime
            ]
            
            products = try await Product.products(for: productIDs)
            
            // تحديث الأسعار
            for product in products {
                let price = product.displayPrice
                switch product.id {
                case ProductID.premiumMonthly:
                    premiumMonthlyPrice = price
                case ProductID.premiumYearly:
                    premiumYearlyPrice = price
                case ProductID.premiumLifetime:
                    premiumLifetimePrice = price
                default:
                    break
                }
            }
        } catch {
            print("❌ Failed to load products: \(error)")
        }
    }
    
    // MARK: - Purchase Methods
    
    /// شراء اشتراك شهري
    func purchaseMonthly() async -> Bool {
        guard let product = products.first(where: { $0.id == ProductID.premiumMonthly }) else {
            return false
        }
        return await purchase(product)
    }
    
    /// شراء اشتراك سنوي
    func purchaseYearly() async -> Bool {
        guard let product = products.first(where: { $0.id == ProductID.premiumYearly }) else {
            return false
        }
        return await purchase(product)
    }
    
    /// شراء Lifetime
    func purchaseLifetime() async -> Bool {
        guard let product = products.first(where: { $0.id == ProductID.premiumLifetime }) else {
            return false
        }
        return await purchase(product)
    }
    
    /// شراء Premium (للتوافق مع الكود القديم)
    func purchasePremium(yearly: Bool) async -> Bool {
        if yearly {
            return await purchaseYearly()
        } else {
            return await purchaseMonthly()
        }
    }
    
    /// شراء منتج
    private func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updatePurchaseStatus()
                await transaction.finish()
                return true
                
            case .pending:
                return false
                
            case .userCancelled:
                return false
                
            @unknown default:
                return false
            }
        } catch {
            print("❌ Purchase failed: \(error)")
            return false
        }
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async -> Bool {
        do {
            try await AppStore.sync()
            await updatePurchaseStatus()
            return isPremium
        } catch {
            print("❌ Restore failed: \(error)")
            return false
        }
    }
    
    // MARK: - Update Purchase Status
    func updatePurchaseStatus() async {
        var hasPremium = false
        var subType: SubscriptionType = .none
        
        // التحقق من الاشتراكات النشطة
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            switch transaction.productID {
            case ProductID.premiumMonthly:
                hasPremium = true
                subType = .monthly
                
            case ProductID.premiumYearly:
                hasPremium = true
                subType = .yearly
                
            case ProductID.premiumLifetime:
                hasPremium = true
                subType = .lifetime
                
            default:
                // القوالب
                if transaction.productID.contains("template") {
                    purchasedTemplates.insert(transaction.productID)
                }
            }
        }
        
        isPremium = hasPremium
        subscriptionType = subType
        saveState()
    }
    
    // MARK: - Listen for Transactions
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            await updatePurchaseStatus()
            await transaction.finish()
        }
    }
    
    // MARK: - Verify Transaction
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw PurchaseError.verification
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Export Management
    
    /// تسجيل تصدير
    func recordExport() {
        guard !isPremium else { return }
        
        if remainingExports > 0 {
            remainingExports -= 1
            saveState()
        }
    }
    
    /// إعادة تعيين التصديرات (للاختبار)
    func resetExports() {
        remainingExports = freeExportLimit
        saveState()
    }
    
    // MARK: - Persistence
    
    private func saveState() {
        UserDefaults.standard.set(isPremium, forKey: "isPremium")
        UserDefaults.standard.set(subscriptionType.rawValue, forKey: "subscriptionType")
        UserDefaults.standard.set(remainingExports, forKey: "remainingExports")
        UserDefaults.standard.set(Array(purchasedTemplates), forKey: "purchasedTemplates")
    }
    
    private func loadSavedState() {
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")
        
        if let typeString = UserDefaults.standard.string(forKey: "subscriptionType"),
           let type = SubscriptionType(rawValue: typeString) {
            subscriptionType = type
        }
        
        remainingExports = UserDefaults.standard.integer(forKey: "remainingExports")
        if remainingExports == 0 && !UserDefaults.standard.bool(forKey: "hasUsedExports") {
            remainingExports = freeExportLimit
        }
        
        if let templates = UserDefaults.standard.array(forKey: "purchasedTemplates") as? [String] {
            purchasedTemplates = Set(templates)
        }
    }
    
    // MARK: - Debug (للاختبار)
    #if DEBUG
    func setDebugPremium(_ value: Bool) {
        isPremium = value
        subscriptionType = value ? .lifetime : .none
        saveState()
    }
    #endif
}

// MARK: - Subscription Type
enum SubscriptionType: String {
    case none
    case monthly
    case yearly
    case lifetime
    
    var displayName: String {
        switch self {
        case .none: return ""
        case .monthly:
            return LocalizationManager.shared.isArabic ? "شهري" : "Monthly"
        case .yearly:
            return LocalizationManager.shared.isArabic ? "سنوي" : "Yearly"
        case .lifetime:
            return LocalizationManager.shared.isArabic ? "مدى الحياة" : "Lifetime"
        }
    }
}

// MARK: - Purchase Error
enum PurchaseError: Error {
    case verification
    case productNotFound
    case purchaseFailed
    
    var localizedDescription: String {
        switch self {
        case .verification:
            return "Transaction verification failed"
        case .productNotFound:
            return "Product not found"
        case .purchaseFailed:
            return "Purchase failed"
        }
    }
}
