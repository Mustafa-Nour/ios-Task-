//
//  authService.swift
//  iOS Task
//
//  Created by Mustafa Nour on 28/01/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    static let shared = AuthService()
    private let db = Firestore.firestore()
    
    func registerUser(name: String, email: String, phone: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = result?.user.uid else { return }
            
            let userData: [String: Any] = [
                "uid": userId,
                "name": name,
                "email": email,
                "phone": phone,
            ]
            
            self?.db.collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func loginUser(phone: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.collection("users").whereField("phone", isEqualTo: phone).limit(to: 1).getDocuments { [weak self] snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first else {
                let noUserError = NSError(domain: "AuthService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No user found with this phone number"])
                completion(.failure(noUserError))
                return
            }
            
            guard let email = document.data()["email"] as? String else {
                let noEmailError = NSError(domain: "AuthService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data is incomplete (missing email)"])
                completion(.failure(noEmailError))
                return
            }
            
            // 3. Sign in with the found email
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
