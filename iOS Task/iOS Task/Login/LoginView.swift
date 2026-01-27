//
//  LoginView.swift
//  iOS Task
//
//  Created by Mustafa Nour on 17/12/2025.
//

import UIKit

class LoginView: UIView {
    let stackView = UIStackView()
    let phoneInputView = PhoneInputView()
    let passwordContainer = UIView()
    let passwordTextField = UITextField()
    var onPickerStateChanged: ((Bool) -> Void)?

    override init(frame: CGRect)  {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 180)
    }
}

extension LoginView {
    
    func updateLanguage(isArabic: Bool) {
        passwordTextField.placeholder = isArabic ? "كلمة المرور" : "Password"
        passwordTextField.textAlignment = isArabic ? .right : .left
        phoneInputView.updateLanguage(isArabic: isArabic)
    }

    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        clipsToBounds = false // allow country picker visibility

        // Stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // Username TextField
        phoneInputView.translatesAutoresizingMaskIntoConstraints = false
        phoneInputView.onPickerStateChanged = { [weak self] isOpen in
            if isOpen {
                self?.superview?.bringSubviewToFront(self!)
                self?.layer.zPosition = 100
            } else {
                self?.layer.zPosition = 0
            }
            self?.onPickerStateChanged?(isOpen)
        }
        
        // Password Container
        passwordContainer.translatesAutoresizingMaskIntoConstraints = false
        passwordContainer.layer.borderWidth = 1
        passwordContainer.layer.borderColor = UIColor.systemGray3.cgColor
        passwordContainer.layer.cornerRadius = 12
        passwordContainer.backgroundColor = .white
        
        // Password TextField
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.borderStyle = .none
    }
    
    func layout() {
        passwordContainer.addSubview(passwordTextField)
        
        stackView.addArrangedSubview(phoneInputView)
        stackView.addArrangedSubview(passwordContainer)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            passwordContainer.heightAnchor.constraint(equalToConstant: 56),
            
            passwordTextField.leadingAnchor.constraint(equalTo: passwordContainer.leadingAnchor, constant: 12),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordContainer.trailingAnchor, constant: -12),
            passwordTextField.centerYAnchor.constraint(equalTo: passwordContainer.centerYAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension LoginView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneInputView.phoneTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
    }
}
