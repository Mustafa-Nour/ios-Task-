//
//  RegisterViewController.swift
//  iOS Task
//
//  Created by Mustafa Nour on 28/01/2026.
//

import UIKit

protocol RegisterViewControllerDelegate: AnyObject {
    func didRegister()
    func didTapLogin()
}

class RegisterViewController: UIViewController {
    
    weak var delegate: RegisterViewControllerDelegate?
    let viewModel = RegisterViewModel()
    
    let languageButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let registerView = RegisterView()
    let registerButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    let loginButton = UIButton(type: .system)
    
    private var languageLeadingConstraint: NSLayoutConstraint!
    private var languageTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupLayout()
        bindViewModel()
        applyLanguageAnimation(animated: false)
    }
    
    func bindViewModel() {
        viewModel.onLanguageChanged = { [weak self] in
            self?.applyLanguageAnimation(animated: true)
        }
    }
}

// MARK: - Setup UI
extension RegisterViewController {
    
    private func setupUI() {
        // Language Button
        languageButton.setTitle("language_button".localized, for: .normal)
        languageButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        languageButton.translatesAutoresizingMaskIntoConstraints = false
        languageButton.addTarget(self, action: #selector(changeLanguageTapped), for: .touchUpInside)
        view.addSubview(languageButton)
        
        // Title Label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "register_title".localized
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        // RegisterView
        registerView.translatesAutoresizingMaskIntoConstraints = false
        registerView.onPickerStateChanged = { [weak self] isOpen in
            if isOpen {
                self?.view.bringSubviewToFront(self?.registerView.superview ?? UIView())
                self?.registerView.superview?.bringSubviewToFront(self?.registerView ?? UIView())
            }
        }
        
        // Error Message
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
        
        // Register Button
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("register".localized, for: .normal)
        registerButton.configuration = .filled()
        registerButton.layer.cornerRadius = 8
        registerButton.addTarget(self, action: #selector(registerTapped), for: .primaryActionTriggered)
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Login Button
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("already_have_account".localized, for: .normal)
        loginButton.configuration = .plain()
        loginButton.addTarget(self, action: #selector(loginTapped), for: .primaryActionTriggered)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupLayout() {
        // Language button constraints
        languageLeadingConstraint = languageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        languageTrailingConstraint = languageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        NSLayoutConstraint.activate([
            languageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        if LanguageManger.shared.isArabic {
            languageTrailingConstraint.isActive = false
            languageLeadingConstraint.isActive = true
        } else {
            languageLeadingConstraint.isActive = false
            languageTrailingConstraint.isActive = true
        }
        
        // Main Stack
        let mainStack = UIStackView(arrangedSubviews: [
            titleLabel,
            registerView,
            errorMessageLabel,
            registerButton,
            loginButton
        ])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        view.addSubview(mainStack)
        
        // Main stack constraints
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Actions
extension RegisterViewController {
    
    @objc func changeLanguageTapped() {
        let newLanguage: AppLanguage = LanguageManger.shared.currentLanguage == .english ? .arabic : .english
        LanguageManger.shared.currentLanguage = newLanguage
        applyLanguageAnimation(animated: true)
    }
    
    @objc func registerTapped() {
        errorMessageLabel.isHidden = true
        
        let name = registerView.nameTextField.text ?? ""
        let phone = registerView.phoneInputView.fullPhoneNumber()
        let password = registerView.passwordTextField.text ?? ""
        let confirmPassword = registerView.confirmPasswordTextField.text ?? ""
        
        let result = viewModel.validateAll(name: name, phone: phone, password: password, confirmPassword: confirmPassword)
        
        switch result {
        case .success:
         
            delegate?.didRegister()
            
        case .failure(let error):
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = viewModel.getErrorMessage(for: error)
        }
    }
    
    @objc func loginTapped() {
        delegate?.didTapLogin()
    }
    
    func applyLanguageAnimation(animated: Bool) {
        titleLabel.text = "register_title".localized
        registerButton.setTitle("register".localized, for: .normal)
        loginButton.setTitle("already_have_account".localized, for: .normal)
        languageButton.setTitle("language_button".localized, for: .normal)
        
        titleLabel.textAlignment = LanguageManger.shared.isArabic ? .right : .left
        registerView.updateLanguage(isArabic: LanguageManger.shared.isArabic)
        
        // Language button constraints
        languageLeadingConstraint.isActive = false
        languageTrailingConstraint.isActive = false
        
        if LanguageManger.shared.isArabic {
            languageLeadingConstraint.isActive = true
        } else {
            languageTrailingConstraint.isActive = true
        }
        
        let animations = { self.view.layoutIfNeeded() }
        animated ? UIView.animate(withDuration: 0.35, animations: animations) : animations()
    }
}
