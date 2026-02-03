//
//  PostViweModel.swift
//  iOS Task
//
//  Created by Mustafa Nour on 03/02/2026.
//

import Foundation
import UIKit

class PostViewModel {
    private(set) var posts: [Post] = []
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchPosts() {
        APIService.shared.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.onDataUpdate?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
