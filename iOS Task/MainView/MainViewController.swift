//
//  MainViewController.swift
//  iOS Task
//
//  Created by Mustafa Nour on 29/01/2026.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        setupViews()
        setTabBar()
    }
    
    private  func setupViews() {
        let  HomeVc = HomeViewController()
        let secondScreenApi = secondScreenApi()
        
        HomeVc.setTapBarImage(imageName: "list.dash.header.rectangle", title: "home_tab".localized)
        secondScreenApi.setTapBarImage(imageName: "arrow.left.arrow.right", title: "api_tab".localized)
        
        
        let dummyNc = UINavigationController(rootViewController: HomeVc)
        let screen2Nc = UINavigationController(rootViewController: secondScreenApi)
        
        //summaryNC.navigationBar.barTintColor = .systemTeal
        hideNavigationBarLine(dummyNc.navigationBar)
        
        let tabBarList = [dummyNc, screen2Nc]
        viewControllers = tabBarList
        
        // Add settings button to each navigation bar
        [dummyNc, screen2Nc].forEach { nc in
            let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsTapped))
            nc.viewControllers.first?.navigationItem.rightBarButtonItem = settingsButton
        }
    }
    
    @objc func settingsTapped() {
        let settingsVC = SettingsViewController()
        if let nc = selectedViewController as? UINavigationController {
            nc.pushViewController(settingsVC, animated: true)
        }
    }
    
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        let img = UIImage()
        navigationBar.shadowImage = img
        navigationBar.setBackgroundImage(img, for: .default)
        navigationBar.isTranslucent = false
    }
    
    private func setTabBar() {
        tabBar.tintColor = .systemRed
        tabBar.isTranslucent = false
    }
    
    
}

