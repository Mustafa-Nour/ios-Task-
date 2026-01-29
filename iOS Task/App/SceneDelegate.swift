import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        self.window = window

        if Auth.auth().currentUser != nil {
            // User is logged in, go to Main
            let mainVC = MainViewController()
            window.rootViewController = mainVC
        } else {
            // User is not logged in, go to Login
            let loginVC = LoginViewController()
            loginVC.delegate = self
            window.rootViewController = loginVC
        }
        
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
        let mainVC = MainViewController()
        setRootViewController(mainVC)
        print("User logged in")
    }
    
    func didTapRegister() {
        print("user Registered")
        let registerVC = RegisterViewController()
        registerVC.delegate = self
        setRootViewController(registerVC)
    }
}

extension SceneDelegate: RegisterViewControllerDelegate {
    func didRegister() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        setRootViewController(loginVC)
    }
    
    func didTapLogin() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        setRootViewController(loginVC)
    }
}


