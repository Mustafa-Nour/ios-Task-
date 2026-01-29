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
        let  dummyvc = HomeViewController()
        let secondScreenApi = secondScreenApi()
        
        dummyvc.setTapBarImage(imageName: "list.dash.header.rectangle", title: "screen1")
        secondScreenApi.setTapBarImage(imageName: "arrow.left.arrow.right", title: "apiScreen")
        
        
        let dummyNc = UINavigationController(rootViewController: dummyvc)
        let screen2 = UINavigationController(rootViewController: secondScreenApi)
        
        //summaryNC.navigationBar.barTintColor = .systemTeal
        hideNavigationBarLine(dummyNc.navigationBar)
        
        let tabBarList = [dummyNc, screen2]
        viewControllers = tabBarList
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

