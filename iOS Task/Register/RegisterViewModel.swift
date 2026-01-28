//
//  RegisterViewModel.swift
//  iOS Task
//
//  Created by Mustafa Nour on 28/01/2026.
//

import Foundation

final class RegisterViewModel {
    
    var onLanguageChanged: (() -> Void)?
    
    var isArabic: Bool {
        LanguageManger.shared.isArabic
    }
    
    // MARK: - Validation Functions
    
    func validateName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespaces).isEmpty && name.count >= 2
    }
    
    func validatePhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{9,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    func validatePasswordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        return password == confirmPassword && !password.isEmpty
    }
    
    // MARK: - Error Messages (Localized)
    func getErrorMessage(for error: ValidationError) -> String {
        switch error {
        case .emptyFields:
            return "error_empty_fields".localized
        case .invalidName:
            return "error_invalid_name".localized
        case .invalidEmail:
            return "error_invalid_email".localized
        case .invalidPhone:
            return "error_invalid_phone".localized
        case .weakPassword:
            return "error_weak_password".localized
        case .passwordMismatch:
            return "error_password_mismatch".localized
        }
    }
    
    // MARK: - Full Validation
    
    func validateAll(name: String, phone: String, password: String, confirmPassword: String) -> Result<Void, ValidationError> {
        
        // Check empty fields
        guard !name.isEmpty, !phone.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            return .failure(.emptyFields)
        }
        
        // Validate name
        guard validateName(name) else {
            return .failure(.invalidName)
        }
        
        // Validate email
        guard validateEmail(email) else {
            return .failure(.invalidEmail)
        }
        
        // Validate phone
        guard validatePhone(phone) else {
            return .failure(.invalidPhone)
        }
        
        // Validate password
        guard validatePassword(password) else {
            return .failure(.weakPassword)
        }
        
        // Validate password match
        guard validatePasswordsMatch(password, confirmPassword) else {
            return .failure(.passwordMismatch)
        }
        
        return .success(())
    }
    
    func toggleLanguage() {
        let newLanguage: AppLanguage = LanguageManger.shared.currentLanguage == .english ? .arabic : .english
        LanguageManger.shared.currentLanguage = newLanguage
        onLanguageChanged?()
    }
}

// MARK: - Validation Error Enum

enum ValidationError: Error {
    case emptyFields
    case invalidName
    case invalidEmail
    case invalidPhone
    case weakPassword
    case passwordMismatch
}
