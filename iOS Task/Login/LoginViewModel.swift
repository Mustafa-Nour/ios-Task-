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
    
    var isArabic: Bool {
        LanguageManger.shared.isArabic
    }
    
    func toggleLanguage() {
        let newLanguage: AppLanguage = LanguageManger.shared.currentLanguage == .english ? .arabic : .english
        LanguageManger.shared.currentLanguage = newLanguage
        onLanguageChanged?()
    }
}
