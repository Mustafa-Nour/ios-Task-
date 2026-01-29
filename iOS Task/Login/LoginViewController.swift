//
//  LoginViewController.swift
//  ios task App
//
//  Created by Mustafa Nour on 17/12/2025.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
    func didTapRegister()
}



class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    let viewModel = LoginViewModel()
    
    let languageButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let loginView = LoginView()
    let signInButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    let registerButton = UIButton(type: .system)
    
    private var languageLeadingConstraint: NSLayoutConstraint!
    private var languageTrailingConstraint: NSLayoutConstraint!
    
    var usernameText: String? {
        return loginView.phoneInputView.phoneTextField.text
    }
    
    var passwordText: String? {
        return loginView.passwordTextField.text
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bindViewModel()
        setupUI()
        setupLayout()
        applyLanguageAnimation(animated: false)
    }
    
    func bindViewModel() {
        viewModel.onLanguageChanged = { [weak self] in
            self?.applyLanguageAnimation(animated: true)
        }
    }
}

// MARK: - Setup UI
extension LoginViewController {
    
    private func setupUI() {
        // Language Button
        languageButton.setTitle("language_button".localized, for: .normal)
        languageButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        languageButton.translatesAutoresizingMaskIntoConstraints = false
        languageButton.addTarget(self, action: #selector(changeLanguageTapped), for: .touchUpInside)
        view.addSubview(languageButton)
        
        // Title Label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "login_title".localized
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        // LoginView
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.onPickerStateChanged = { [weak self] isOpen in
            if isOpen {
                self?.view.bringSubviewToFront(self?.loginView.superview ?? UIView())
                self?.loginView.superview?.bringSubviewToFront(self?.loginView ?? UIView())
            }
        }
        
        // Error Message
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
        
        // Sign In Button
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("sign_in".localized, for: .normal)
        signInButton.configuration = .filled()
        signInButton.layer.cornerRadius = 8
        signInButton.addTarget(self, action: #selector(loginTapped), for: .primaryActionTriggered)
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Register Button
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("register".localized, for: .normal)
        registerButton.configuration = .filled()
        registerButton.layer.cornerRadius = 8
        registerButton.addTarget(self, action: #selector(registerTapped), for: .primaryActionTriggered)
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
            loginView,
            errorMessageLabel,
            signInButton,
            registerButton
        ])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 16
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
extension LoginViewController {
    
    @objc func changeLanguageTapped() {
        let newLanguage: AppLanguage = LanguageManger.shared.currentLanguage == .english ? .arabic : .english
        LanguageManger.shared.currentLanguage = newLanguage
        applyLanguageAnimation(animated: true)

    }

    @objc func loginTapped() {
        errorMessageLabel.isHidden = true
        
        let phone = loginView.phoneInputView.fullPhoneNumber()
        guard let password = loginView.passwordTextField.text, !password.isEmpty else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "error_empty_fields".localized
            loginView.passwordTextField.layer.borderColor = UIColor.systemRed.cgColor
            return
        }
        
        // Show loading or disable button if needed
        AuthService.shared.loginUser(phone: phone, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Login successful!")
                    self?.delegate?.didLogin()
                case .failure(let error):
                    print("Login error: \(error.localizedDescription)")
                    self?.errorMessageLabel.isHidden = false
                    self?.errorMessageLabel.text = error.localizedDescription
                }
            }
        }
    }
    
    @objc func registerTapped() {
        delegate?.didTapRegister()
    }
    
    func applyLanguageAnimation(animated: Bool) {
        
        titleLabel.text = "login_title".localized
        signInButton.setTitle("sign_in".localized, for: .normal)
        registerButton.setTitle("register".localized, for: .normal)
        languageButton.setTitle("language_button".localized, for: .normal)
        
        titleLabel.textAlignment = LanguageManger.shared.isArabic ? .right : .left
        loginView.updateLanguage(isArabic: LanguageManger.shared.isArabic)
        
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
