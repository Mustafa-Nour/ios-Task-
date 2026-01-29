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
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        languageButton.setTitle("Change Language", for: .normal)
        languageButton.addTarget(self, action: #selector(languageTapped), for: .touchUpInside)
        
        logoutButton.setTitle("Logout", for: .normal)
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
        
        let alert = UIAlertController(title: "Language Changed", message: "Please restart the app to apply changes.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
