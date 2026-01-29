//
//  LanguageManger.swift
//  iOS Task
//
//  Created by Mustafa Nour on 27/01/2026.
//

import Foundation
enum AppLanguage: String {
    case english = "en"
    case arabic = "ar"
}
class LanguageManger {
    static let shared = LanguageManger()
    
    private let languageKey = "AppLanguage"
    
    var currentLanguage: AppLanguage {
        get {
            if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
               let language = AppLanguage(rawValue: savedLanguage) {
                return language
            }
            return .english
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: languageKey)
            UserDefaults.standard.synchronize()
            
            // Update app language
            UserDefaults.standard.set([newValue.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isArabic: Bool {
        return currentLanguage == .arabic
    }
}
