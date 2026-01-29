//
//  LanguageManger.swift
//  iOS Task
//
//  Created by Mustafa Nour on 27/01/2026.
//

import Foundation
import UIKit

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
            
            // Update UI direction
            let semantic: UISemanticContentAttribute = (newValue == .arabic) ? .forceRightToLeft : .forceLeftToRight
            UIView.appearance().semanticContentAttribute = semantic
        }
    }
    
    var isArabic: Bool {
        return currentLanguage == .arabic
    }
}
