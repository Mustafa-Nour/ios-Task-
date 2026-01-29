//
//  dummyVc.swift
//  iOS Task
//
//  Created by Mustafa Nour on 29/01/2026.
//

import Foundation
import UIKit

class HomeViewController: UIViewController{
    
    let symbols = ["house", "star.fill", "heart.fill", "bell.fill", "person.circle", "gear", "map", "cart.fill"]
    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
    
    let horizontalLabel = UILabel()
    let verticalLabel = UILabel()
    
    lazy var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 180)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.dataSource = self // 👈 مهم جداً
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let verticalStack = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        
        style()
        layout()
        setupVerticalItems()
    }
    
}

extension HomeViewController {
    func style() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        horizontalLabel.text = "Horizontal Scroll view"
        horizontalLabel.font = .boldSystemFont(ofSize: 22)
        
        verticalLabel.text = "Vertical scroll View "
        verticalLabel.font = .boldSystemFont(ofSize: 22)
        
        verticalStack.axis = .vertical
        verticalStack.spacing = 12
    }
    
    func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(horizontalLabel)
        stackView.addArrangedSubview(horizontalCollectionView)
        stackView.addArrangedSubview(verticalLabel)
        stackView.addArrangedSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // StackView Constraints
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // CollectionView
            horizontalCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Verical items
    func setupVerticalItems() {
        for symbol in symbols {
            let rowView = UIView()
            rowView.backgroundColor = .systemGray6
            rowView.layer.cornerRadius = 10
            rowView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            let icon = UIImageView(image: UIImage(systemName: symbol))
            icon.translatesAutoresizingMaskIntoConstraints = false
            rowView.addSubview(icon)
            
            NSLayoutConstraint.activate([
                icon.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 16),
                icon.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
                icon.widthAnchor.constraint(equalToConstant: 30),
                icon.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            verticalStack.addArrangedSubview(rowView)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 15
        
        let icon = UIImageView(image: UIImage(systemName: symbols[indexPath.row]))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.frame = cell.contentView.bounds.insetBy(dx: 30, dy: 30)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(icon)
        return cell
    }
}
