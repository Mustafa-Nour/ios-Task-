//
//  UIViewController+utills.swift
//  Bankey App
//


import Foundation
import UIKit

extension UIViewController {
    func setStatusBar() {
        let statusBarHeight: CGFloat = {
            if let windowScene = view.window?.windowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let height = windowScene.statusBarManager?.statusBarFrame.height {
                return height
            }
            return 0
        }()

        // If height is zero, avoid adding an unnecessary view
        guard statusBarHeight > 0 else { return }

        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight)
        let statusBarView = UIView(frame: frame)
        statusBarView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        statusBarView.backgroundColor = .systemBlue
        view.addSubview(statusBarView)
    }
    
    func setTapBarImage (imageName: String, title: String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
}

