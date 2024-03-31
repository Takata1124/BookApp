//
//  HomeViewModel.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class HomeViewModel {
    
    init() {
        
        SqliteManager.shared.openDB()
        SqliteManager.shared.createTable()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Task {
            do {
                let isbns = try await getFireStore(uid: uid)
                SqliteManager.shared.selectItem { items, err  in
                    if err != nil {
                        return
                    }
                    if let items = items {
                        _ = items.map { item in
                            self.setupFireStore(item: item, uid: uid, isbns: isbns)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getFireStore(uid: String) async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            Firestore.firestore().collection("books").whereField("uid", in: [uid]).getDocuments(completion: { snapshots, error in
                var isbns: [String] = []
                if let error = error {
                    continuation.resume(throwing: error)
                }
                for document in snapshots!.documents {
                    let dic = document.data()
                    let isbn = dic["isbn"] as? String ?? ""
                    isbns.append(isbn)
                }
                continuation.resume(returning: isbns)
            })
        }
    }
    
    func setupFireStore(item: Item, uid: String, isbns: [String]) {
        if isbns.contains(item.isbn) { return }
        Firestore.firestore().collection("books").document().setData([
            "uid": uid,
            "title": item.title,
            "author": item.author,
            "isbn": item.isbn,
            "salesDate": item.salesDate,
            "largeImageUrl": item.largeImageUrl
        ], merge: false) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
