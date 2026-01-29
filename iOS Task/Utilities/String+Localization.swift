//
//  String+Localization.swift
//  iOS Task
//
//  Created by Mustafa Nour on 28/01/2026.
//

import Foundation

extension String {
    var localized: String {
        let language = LanguageManger.shared.currentLanguage.rawValue
        
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
