//
//  FirebaseManager.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth

class FirebaseManger {
    
    static let shared: FirebaseManger = .init()
    
    static func setupFirebaseUser(email: String, password: String) async throws -> AuthDataResult {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                if let authResult = authResult {
                    continuation.resume(returning: authResult)
                }
            }
        }
    }
    
    static func firebaseSignIn(email: String, password: String) async throws -> AuthDataResult {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                if let authResult = authResult {
                    continuation.resume(returning: authResult)
                }
            }
        }
    }
    
    static func firebaseLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}


