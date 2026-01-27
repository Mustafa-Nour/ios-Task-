//
//  LoginView.swift
//  iOS Task
//
//  Created by Mustafa Nour on 17/12/2025.
//

import UIKit

class LoginView: UIView {
    let stackView = UIStackView()
    let PhoneTextField = UITextField()
    let passwordTextField = UITextField()

    override init(frame: CGRect)  {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 150)
    }
}

extension LoginView {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        clipsToBounds = true

        // Stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        // Username TextField
        PhoneTextField.translatesAutoresizingMaskIntoConstraints = false
        PhoneTextField.placeholder = "Phone"
        PhoneTextField.delegate = self
        PhoneTextField.borderStyle = .roundedRect
        PhoneTextField.autocapitalizationType = .none
        PhoneTextField.autocorrectionType = .no
        PhoneTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Password TextField
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func layout() {
        stackView.addArrangedSubview(PhoneTextField)
        stackView.addArrangedSubview(passwordTextField)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension LoginView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == PhoneTextField {
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
