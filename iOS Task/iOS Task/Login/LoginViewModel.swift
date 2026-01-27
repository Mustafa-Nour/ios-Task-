//
//  LoginViewModel.swift
//  iOS Task
//
//  Created by Mustafa Nour on 27/01/2026.
//
import Foundation
import UIKit

final class LoginViewModel {
    
    var onLanguageChanged: (() -> Void)?
    
    var language: AppLanguage {
        LanguageManger.shared.currentLanguage
    }
    
    func toggleLanguage() {
        let newLanguage: AppLanguage =
            language == .english ? .arabic : .english
        
        LanguageManger.shared.currentLanguage = newLanguage
        onLanguageChanged?()
    }
    
    var isArabic: Bool {
        language == .arabic
    }
    
    var titleText: String {
        isArabic ? "تسجيل الدخول" : "Login"
    }
    
    var signInText: String {
        isArabic ? "دخول" : "Sign In"
    }
    
    var registerText: String {
        isArabic ? "تسجيل" : "Register"
    }
    
    var languageButtonText: String {
        isArabic ? "English" : "العربية"
    }
    
    var errprMessageTExt: String {
        isArabic ?  "الرجاء ملئ جميع الحقول": "Phone Number/Password should never be empty"
    }
}
