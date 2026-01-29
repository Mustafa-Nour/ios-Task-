import Foundation
import Network

class APIService {
    static let shared = APIService()
    private let monitor = NWPathMonitor()
    private var isConnected = true
    
    private let cacheFile = "posts_cache.json"
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .internetConnectionLost, object: nil)
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        if isConnected {
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    self.cachePosts(data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        } else {
            // Load from offline cache
            if let cachedData = loadCachedPosts() {
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: cachedData)
                    completion(.success(posts))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "Offline", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet and no cached data"])))
            }
        }
    }
    
    private func cachePosts(_ data: Data) {
        let url = getCacheURL()
        try? data.write(to: url)
    }
    
    private func loadCachedPosts() -> Data? {
        let url = getCacheURL()
        return try? Data(contentsOf: url)
    }
    
    private func getCacheURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(cacheFile)
    }
}

extension NSNotification.Name {
    static let internetConnectionLost = NSNotification.Name("internetConnectionLost")
}
