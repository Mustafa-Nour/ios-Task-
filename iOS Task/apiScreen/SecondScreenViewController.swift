//
//  SecondScreen.swift
//  iOS Task
//
//  Created by Mustafa Nour on 29/01/2026.
//

import Foundation
import UIKit
class secondScreenApi: UIViewController{
    let stackView = UIStackView()
    let Label = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
}

extension secondScreenApi {
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.text = "Welcome"
        Label.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    func layout() {
        stackView.addArrangedSubview(Label)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo:  view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo:  view.centerYAnchor)
        ])
    }
}
