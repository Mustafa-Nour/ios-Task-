import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    let stackView = UIStackView()
    let languageButton = UIButton(type: .system)
    let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "settings_title".localized
        view.backgroundColor = .systemBackground
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        languageButton.setTitle("change_language".localized, for: .normal)
        languageButton.addTarget(self, action: #selector(languageTapped), for: .touchUpInside)
        
        logoutButton.setTitle("logout".localized, for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(languageButton)
        stackView.addArrangedSubview(logoutButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func languageTapped() {
        let isArabic = LanguageManger.shared.isArabic
        LanguageManger.shared.currentLanguage = isArabic ? .english : .arabic
        
        // Refresh the entire app UI
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            let mainVC = MainViewController()
            sceneDelegate.setRootViewController(mainVC)
            
            // Navigate back to settings in the new language
            if let nc = mainVC.selectedViewController as? UINavigationController {
                nc.pushViewController(SettingsViewController(), animated: false)
            }
        }
    }
    
    @objc func logoutTapped() {
        do {
            try AuthService.shared.signOut()
            // Notify SceneDelegate to switch root
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                let loginVC = LoginViewController()
                loginVC.delegate = sceneDelegate
                sceneDelegate.setRootViewController(loginVC)
            }
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
