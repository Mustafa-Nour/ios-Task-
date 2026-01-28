import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let loginVC = LoginViewController()
        loginVC.delegate = self
        window.rootViewController = loginVC
        window.backgroundColor = .systemBackground
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        
        window.rootViewController = vc
        
        if animated {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}

extension SceneDelegate: LoginViewControllerDelegate {
    func didLogin() {
        print("User logged in")
    }
    
    func didTapRegister() {
        let registerVC = RegisterViewController()
        registerVC.delegate = self
        setRootViewController(registerVC)
    }
}

extension SceneDelegate: RegisterViewControllerDelegate {
    func didRegister() {
        // TODO: Navigate to MainViewController after successful registration
        print("User registered")
    }
    
    func didTapLogin() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        setRootViewController(loginVC)
    }
}


