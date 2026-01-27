//
//  LanguageManger.swift
//  iOS Task
//
//  Created by Mustafa Nour on 27/01/2026.
//

import Foundation
 
// MARK: - singleton designPattern
final class LanguageManger {
    
    static let shared = LanguageManger()
    
    private let key = "app_Language"
    
    private init () {}
    
    var currentLanguage: AppLanguage {
        get {
            let saved = UserDefaults.standard.string(forKey: key)
            return AppLanguage(rawValue: saved ?? "") ?? .english
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
        }
    }
    
    
}

enum AppLanguage : String {
    case english = "en"
    case arabic = "ar"
}
