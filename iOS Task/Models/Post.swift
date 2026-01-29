import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

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
