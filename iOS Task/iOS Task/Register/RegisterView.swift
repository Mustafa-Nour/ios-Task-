//
//  RegisterView.swift
//  iOS Task
//
//  Created by Mustafa Nour on 28/01/2026.
//

import UIKit

class RegisterView: UIView {
    
    let stackView = UIStackView()
    let nameContainer = UIView()
    let nameTextField = UITextField()
    let phoneInputView = PhoneInputView()
    let passwordContainer = UIView()
    let passwordTextField = UITextField()
    let confirmPasswordContainer = UIView()
    let confirmPasswordTextField = UITextField()
    
    var onPickerStateChanged: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 300)
    }
}

extension RegisterView {
    
    func updateLanguage(isArabic: Bool) {
        nameTextField.placeholder = "name".localized
        nameTextField.textAlignment = isArabic ? .right : .left
        
        passwordTextField.placeholder = "password".localized
        passwordTextField.textAlignment = isArabic ? .right : .left
        
        confirmPasswordTextField.placeholder = "confirm_password".localized
        confirmPasswordTextField.textAlignment = isArabic ? .right : .left
        
        phoneInputView.updateLanguage(isArabic: isArabic)
    }
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        clipsToBounds = false
        
        // Stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // Name Container
        setupContainer(nameContainer, textField: nameTextField, placeholder: "name".localized)
        
        // Phone Input
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
        setupContainer(passwordContainer, textField: passwordTextField, placeholder: "password".localized, isSecure: true)
        
        // Confirm Password Container
        setupContainer(confirmPasswordContainer, textField: confirmPasswordTextField, placeholder: "confirm_password".localized, isSecure: true)
    }
    
    private func setupContainer(_ container: UIView, textField: UITextField, placeholder: String, isSecure: Bool = false) {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray3.cgColor
        container.layer.cornerRadius = 12
        container.backgroundColor = .white
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.delegate = self
        textField.borderStyle = .none
    }
    
    func layout() {
        // Add textfields to containers
        nameContainer.addSubview(nameTextField)
        passwordContainer.addSubview(passwordTextField)
        confirmPasswordContainer.addSubview(confirmPasswordTextField)
        
        // Add to stack
        stackView.addArrangedSubview(nameContainer)
        stackView.addArrangedSubview(phoneInputView)
        stackView.addArrangedSubview(passwordContainer)
        stackView.addArrangedSubview(confirmPasswordContainer)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            nameContainer.heightAnchor.constraint(equalToConstant: 56),
            nameTextField.leadingAnchor.constraint(equalTo: nameContainer.leadingAnchor, constant: 12),
            nameTextField.trailingAnchor.constraint(equalTo: nameContainer.trailingAnchor, constant: -12),
            nameTextField.centerYAnchor.constraint(equalTo: nameContainer.centerYAnchor),
            
            passwordContainer.heightAnchor.constraint(equalToConstant: 56),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordContainer.leadingAnchor, constant: 12),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordContainer.trailingAnchor, constant: -12),
            passwordTextField.centerYAnchor.constraint(equalTo: passwordContainer.centerYAnchor),
            
            confirmPasswordContainer.heightAnchor.constraint(equalToConstant: 56),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: confirmPasswordContainer.leadingAnchor, constant: 12),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: confirmPasswordContainer.trailingAnchor, constant: -12),
            confirmPasswordTextField.centerYAnchor.constraint(equalTo: confirmPasswordContainer.centerYAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension RegisterView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            phoneInputView.phoneTextField.becomeFirstResponder()
        } else if textField == phoneInputView.phoneTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.endEditing(true)
        }
        return true
    }
}
