//
//  ViewController.swift
//  ios task App
//
//  Created by Mustafa Nour on 17/12/2025.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

class LoginViewController: UIViewController {
    
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
        return loginView.PhoneTextField.text
    }
    
    var passwordText: String? {
        return loginView.passwordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bindViewModel()
        setup()
        layout()
        applyLanguageAnimation(animated: false)
        
    }
    
    func bindViewModel() {
        viewModel.onLanguageChanged = { [weak self] in
            self?.applyLanguageAnimation(animated: true)
        }
    }
}

extension LoginViewController {

    private func setup() {
        
        //language button setup
        languageButton.setTitle("English", for: .normal)
        languageButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        languageButton.translatesAutoresizingMaskIntoConstraints = false
        let isArabic = UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .leftToRight
        view.addSubview(languageButton)
        
          languageLeadingConstraint = languageButton.leadingAnchor
            .constraint(equalTo: view.leadingAnchor, constant: 16)
        
          languageTrailingConstraint = languageButton.trailingAnchor
            .constraint(equalTo: view.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            languageButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            )
        ])
        
        languageButton.addTarget(self, action: #selector(changeLanguageTapped), for: .touchUpInside)
        
        //titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Login"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontForContentSizeCategory = true
        
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        //signinButton
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Sign In", for: [])
        signInButton.configuration = .filled()
        signInButton.layer.cornerRadius = 8
        signInButton.configuration?.imagePadding = 8
        signInButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        signInButton.addTarget(self, action: #selector(loginTapped), for: .primaryActionTriggered)
        
        //errorMessageLabel
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
        
        //RegisterButton
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: [])
        registerButton.configuration = .filled()
        registerButton.layer.cornerRadius = 8
        registerButton.configuration?.imagePadding = 8
        registerButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        registerButton.addTarget(self, action: #selector(loginTapped), for: .primaryActionTriggered)

    }
    
    private func layout() {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            loginView,
            signInButton,
            errorMessageLabel,
            registerButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        view.addSubview(stackView)
        
        //stackView
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: loginView.leadingAnchor, multiplier: 1)
        ])
        
        //signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension LoginViewController {
    
    @objc func changeLanguageTapped() {
        viewModel.toggleLanguage()
    }
    
    @objc func loginTapped(sender: UIButton) {
        errorMessageLabel.isHidden = true
        login()
    }
    
    func login() {
        guard let usernameText = usernameText, let passwordText = passwordText else {
            assertionFailure(viewModel.errprMessageTExt)
            return
        }
        
        if usernameText.isEmpty || passwordText.isEmpty {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = viewModel.errprMessageTExt
            return
        }
    }
    
    
    func applyLanguageAnimation( animated: Bool){
        let isArabic = viewModel.isArabic
        
        titleLabel.textAlignment = isArabic ? .right : .left
        //signInButton.contentHorizontalAlignment = isArabic ? .right : .left
        
        titleLabel.text = viewModel.titleText
        signInButton.setTitle(viewModel.signInText, for: .normal)
        languageButton.setTitle(viewModel.languageButtonText, for: .normal)
        registerButton.setTitle(viewModel.registerText, for: .normal)
        errorMessageLabel.text = viewModel.errprMessageTExt
        
        languageLeadingConstraint.isActive = false
        languageTrailingConstraint.isActive = false
        
        if isArabic {
            languageLeadingConstraint.isActive = true
        } else {
            languageTrailingConstraint.isActive = true
        }
        
        let animations = {
            self.view.layoutIfNeeded()
        }
        
        animated ? UIView.animate(withDuration: 0.35, animations: animations) : animations()
    }
    
    
    
}
