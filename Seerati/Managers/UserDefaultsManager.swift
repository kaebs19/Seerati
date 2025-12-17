//
//  UserDefaultsManager.swift
//  Seerati
//
//  Path: Seerati/Managers/UserDefaultsManager.swift
//

import Foundation

// MARK: - UserDefaults Manager
/// مدير إعدادات المستخدم
final class UserDefaultsManager {
    
    // MARK: - Singleton
    static let shared = UserDefaultsManager()
    
    // MARK: - Keys
    private enum Keys {
        static let language = "app_language"
        static let hasCompletedOnboarding = "has_completed_onboarding"
        static let lastSelectedTemplateId = "last_selected_template_id"
        static let isPremiumUser = "is_premium_user"
        static let defaultTemplateId = "default_template_id"
        static let autoSaveEnabled = "auto_save_enabled"
        static let userName = "user_name"
        static let userEmail = "user_email"
        static let userPhone = "user_phone"
        static let userPhoto = "user_photo_data"
        static let userLocation = "user_location"
        static let userWebsite = "user_website"
        static let exportQuality = "export_quality"
        static let lastExportDate = "last_export_date"
        static let totalExportsCount = "total_exports_count"
        static let appOpenCount = "app_open_count"
        static let lastReviewPromptDate = "last_review_prompt_date"
    }
    
    // MARK: - Private Properties
    private let defaults = UserDefaults.standard
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Language
    var language: String {
        get { defaults.string(forKey: Keys.language) ?? Language.default.rawValue }
        set { defaults.set(newValue, forKey: Keys.language) }
    }
    
    // MARK: - Onboarding
    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
    
    // MARK: - Template
    var lastSelectedTemplateId: String? {
        get { defaults.string(forKey: Keys.lastSelectedTemplateId) }
        set { defaults.set(newValue, forKey: Keys.lastSelectedTemplateId) }
    }
    
    var defaultTemplateId: String {
        get { defaults.string(forKey: Keys.defaultTemplateId) ?? "swiss_minimal" }
        set { defaults.set(newValue, forKey: Keys.defaultTemplateId) }
    }
    
    // MARK: - Premium
    var isPremiumUser: Bool {
        get { defaults.bool(forKey: Keys.isPremiumUser) }
        set { defaults.set(newValue, forKey: Keys.isPremiumUser) }
    }
    
    // MARK: - Settings
    var autoSaveEnabled: Bool {
        get { defaults.object(forKey: Keys.autoSaveEnabled) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.autoSaveEnabled) }
    }
    
    var exportQuality: ExportQuality {
        get {
            guard let rawValue = defaults.string(forKey: Keys.exportQuality),
                  let quality = ExportQuality(rawValue: rawValue) else {
                return .high
            }
            return quality
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.exportQuality) }
    }
    
    // MARK: - User Info (للتعبئة السريعة)
    var userName: String? {
        get { defaults.string(forKey: Keys.userName) }
        set { defaults.set(newValue, forKey: Keys.userName) }
    }
    
    var userEmail: String? {
        get { defaults.string(forKey: Keys.userEmail) }
        set { defaults.set(newValue, forKey: Keys.userEmail) }
    }
    
    var userPhone: String? {
        get { defaults.string(forKey: Keys.userPhone) }
        set { defaults.set(newValue, forKey: Keys.userPhone) }
    }
    
    var userPhotoData: Data? {
        get { defaults.data(forKey: Keys.userPhoto) }
        set { defaults.set(newValue, forKey: Keys.userPhoto) }
    }
    
    var userLocation: String? {
        get { defaults.string(forKey: Keys.userLocation) }
        set { defaults.set(newValue, forKey: Keys.userLocation) }
    }
    
    var userWebsite: String? {
        get { defaults.string(forKey: Keys.userWebsite) }
        set { defaults.set(newValue, forKey: Keys.userWebsite) }
    }
    
    // MARK: - Statistics
    var totalExportsCount: Int {
        get { defaults.integer(forKey: Keys.totalExportsCount) }
        set { defaults.set(newValue, forKey: Keys.totalExportsCount) }
    }
    
    var lastExportDate: Date? {
        get { defaults.object(forKey: Keys.lastExportDate) as? Date }
        set { defaults.set(newValue, forKey: Keys.lastExportDate) }
    }
    
    var appOpenCount: Int {
        get { defaults.integer(forKey: Keys.appOpenCount) }
        set { defaults.set(newValue, forKey: Keys.appOpenCount) }
    }
    
    var lastReviewPromptDate: Date? {
        get { defaults.object(forKey: Keys.lastReviewPromptDate) as? Date }
        set { defaults.set(newValue, forKey: Keys.lastReviewPromptDate) }
    }
    
    // MARK: - Methods
    /// زيادة عداد فتح التطبيق
    func incrementAppOpenCount() {
        appOpenCount += 1
    }
    
    /// زيادة عداد التصدير
    func incrementExportCount() {
        totalExportsCount += 1
        lastExportDate = Date()
    }
    
    /// هل يجب عرض طلب التقييم؟
    var shouldShowReviewPrompt: Bool {
        // عرض طلب التقييم بعد 5 مرات فتح و 2 تصدير على الأقل
        guard appOpenCount >= 5, totalExportsCount >= 2 else { return false }
        
        // لا تعرض أكثر من مرة كل 30 يوم
        if let lastPrompt = lastReviewPromptDate {
            let daysSinceLastPrompt = Calendar.current.dateComponents([.day], from: lastPrompt, to: Date()).day ?? 0
            return daysSinceLastPrompt >= 30
        }
        
        return true
    }
    
    /// إعادة تعيين جميع الإعدادات
    func resetAll() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
    
    /// حفظ معلومات المستخدم للاستخدام السريع
    func saveUserInfo(name: String?, email: String?, phone: String?, photo: Data?) {
        userName = name
        userEmail = email
        userPhone = phone
        userPhotoData = photo
    }
}

// MARK: - Export Quality
enum ExportQuality: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var scale: CGFloat {
        switch self {
        case .low: return 1.0
        case .medium: return 2.0
        case .high: return 3.0
        }
    }
    
    var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var arabicName: String {
        switch self {
        case .low: return "منخفضة"
        case .medium: return "متوسطة"
        case .high: return "عالية"
        }
    }
}
