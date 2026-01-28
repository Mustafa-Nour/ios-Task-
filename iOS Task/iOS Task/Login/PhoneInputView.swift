//
//  PhoneTextFieldCustomView.swift
//  iOS Task
//
//  Created by Mustafa Nour on 27/01/2026.
//

import Foundation
import UIKit

// MARK: - Model
struct Country {
    let name: String
    let code: String
    let flag: String
    let maxLength: Int
}

final class PhoneInputView: UIView {
    
    private var pickerConstraints: [NSLayoutConstraint] = []

    
    private let countries: [Country] = [
        .init(name: "مصر", code: "+20", flag: "🇪🇬", maxLength: 10),
        .init(name: "السعودية", code: "+966", flag: "🇸🇦", maxLength: 9),
        .init(name: "البحرين", code: "+973", flag: "🇧🇭", maxLength: 8),
        .init(name: "الإمارات العربية المتحدة", code: "+971", flag: "🇦🇪", maxLength: 9),
        .init(name: "الكويت", code: "+965", flag: "🇰🇼", maxLength: 8),
        .init(name: "عمان", code: "+968", flag: "🇴🇲", maxLength: 8)
    ]
    
    private var selectedCountry: Country!
    private var isPickerOpen = false
    var onPickerStateChanged: ((Bool) -> Void)?
    
    // MARK: UI
     let container = UIView()
     let stack = UIStackView()
    
     let countryButton = UIButton(type: .system)
     let arrowImage = UIImageView()
     let codeLabel = UILabel()
     let phoneTextField = UITextField()
    
     let pickerContainer = UIView()
     let tableView = UITableView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        selectedCountry = countries.first!
        setupUI()
        setupPicker()
        applyCountry(selectedCountry)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectedCountry = countries.first!
        setupUI()
        setupPicker()
        applyCountry(selectedCountry)
    }
    
    // MARK: Setup UI
   
}

extension PhoneInputView {
    
    // MARK: - Setup and Layout
    private func setupUI() {
        // container
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray3.cgColor
        container.layer.cornerRadius = 12
        container.backgroundColor = .white
        addSubview(container)
        
        // stack
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        container.addSubview(stack)
        
        // country button
        countryButton.titleLabel?.font = .systemFont(ofSize: 20)
        countryButton.addTarget(self, action: #selector(togglePicker), for: .touchUpInside)
        
        // arrow
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.image = UIImage(systemName: "chevron.down")
        arrowImage.tintColor = .systemBlue
        arrowImage.contentMode = .scaleAspectFit
        
        // code
        codeLabel.font = .systemFont(ofSize: 16)
        
        // textfield
        phoneTextField.placeholder = "phone"
        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self
        phoneTextField.borderStyle = .none
        
        // add to stack
        [countryButton, arrowImage, codeLabel, phoneTextField].forEach {
            stack.addArrangedSubview($0)
        }
        
        layoutMain()
    }
    
    private func layoutMain() {
        container.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 56),
            
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            
            arrowImage.widthAnchor.constraint(equalToConstant: 16),
            arrowImage.heightAnchor.constraint(equalToConstant: 16),
            countryButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        phoneTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        countryButton.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    // MARK: Picker
    
    private func setupPicker() {
        pickerContainer.layer.cornerRadius = 12
        pickerContainer.backgroundColor = .systemBackground
        pickerContainer.isHidden = true
        pickerContainer.layer.borderWidth = 1
        pickerContainer.layer.borderColor = UIColor.systemGray4.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        
        pickerContainer.addSubview(tableView)
        
        pickerContainer.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: pickerContainer.topAnchor, constant: 4),
            tableView.bottomAnchor.constraint(equalTo: pickerContainer.bottomAnchor, constant: -4),
            tableView.leadingAnchor.constraint(equalTo: pickerContainer.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: pickerContainer.trailingAnchor, constant: -4)
        ])
        
        // Shadow for picker
        pickerContainer.layer.shadowColor = UIColor.black.cgColor
        pickerContainer.layer.shadowOffset = CGSize(width: 0, height: 8)
        pickerContainer.layer.shadowOpacity = 0.3
        pickerContainer.layer.shadowRadius = 12
        pickerContainer.layer.masksToBounds = false
    }
    
    // MARK: Actions and validations
    @objc private func togglePicker() {
        isPickerOpen.toggle()
        
        if isPickerOpen {
            showPickerInWindow()
        } else {
            hidePickerFromWindow()
        }
        
        arrowImage.image = UIImage(systemName: isPickerOpen ? "chevron.up" : "chevron.down")
        onPickerStateChanged?(isPickerOpen)
    }
    
    private func showPickerInWindow() {
        guard let window = self.window else { return }
        
        // Remove from current superview if exists
        pickerContainer.removeFromSuperview()
        
        // Add to window
        window.addSubview(pickerContainer)
        
        // Calculate position in window coordinates
        let containerFrameInWindow = container.convert(container.bounds, to: window)
        
        // Remove old constraints
        NSLayoutConstraint.deactivate(pickerConstraints)
        pickerConstraints.removeAll()
        
        // Create new constraints relative to window
        pickerConstraints = [
            pickerContainer.topAnchor.constraint(equalTo: window.topAnchor, constant: containerFrameInWindow.maxY + 4),
            pickerContainer.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: containerFrameInWindow.minX),
            pickerContainer.widthAnchor.constraint(equalToConstant: containerFrameInWindow.width),
            pickerContainer.heightAnchor.constraint(equalToConstant: 260)
        ]
        
        NSLayoutConstraint.activate(pickerConstraints)
        pickerContainer.isHidden = false
    }
    
    private func hidePickerFromWindow() {
        pickerContainer.isHidden = true
        pickerContainer.removeFromSuperview()
        NSLayoutConstraint.deactivate(pickerConstraints)
        pickerConstraints.removeAll()
    }
    
    func updateLanguage(isArabic: Bool) {
        phoneTextField.placeholder = isArabic ? "رقم الهاتف" : "Phone number"
        phoneTextField.textAlignment = isArabic ? .right : .left
        
      
    }

    private func applyCountry(_ country: Country) {
        selectedCountry = country
        countryButton.setTitle(country.flag, for: .normal)
        codeLabel.text = country.code
        setError(false)
        print("DEBUG: Applied country \(country.name) with flag \(country.flag) and code \(country.code)")
    }
    
    func validate() -> Bool {
        let isValid = (phoneTextField.text?.count ?? 0) == selectedCountry.maxLength
        setError(!isValid)
        return isValid
    }
    
    func fullPhoneNumber() -> String {
        "\(selectedCountry.code)\(phoneTextField.text ?? "")"
    }
    
    func setError(_ show: Bool) {
        container.layer.borderColor = show
            ? UIColor.systemRed.cgColor
            : UIColor.systemGray3.cgColor
    }
    
}

// MARK: - TextField Delegate
extension PhoneInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String
    ) -> Bool {
        
        let allowed = CharacterSet.decimalDigits
        let set = CharacterSet(charactersIn: string)
        guard allowed.isSuperset(of: set) else { return false }
        
        let current = textField.text ?? ""
        let updated = (current as NSString).replacingCharacters(in: range, with: string)
        return updated.count <= selectedCountry.maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setError(false)
        if !pickerContainer.isHidden {
            togglePicker()
        }
    }
}

// MARK: - TableView
extension PhoneInputView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let c = countries[indexPath.row]
        cell.textLabel?.text = "\(c.flag)  \(c.name)   \(c.code)"
        cell.textLabel?.font = .systemFont(ofSize: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        applyCountry(countries[indexPath.row])
        togglePicker()
    }
}
