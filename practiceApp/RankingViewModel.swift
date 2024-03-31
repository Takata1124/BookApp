//
//  RankingViewModel.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/30.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth
import FirebaseFirestore

class RankingViewModel: BaseViewModel {
    
    let subject = PublishSubject<BooksData>()
    
    override init() {
        
    }
    
    func setupUserName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("books").whereField("uid", in: [uid]).getDocuments(completion: { snapshots, error in
            if let error = error {
                self.subject.onError(error)
            }
            for document in snapshots!.documents {
                let dic = document.data()
                let books = BooksData(dic: dic)
                self.subject.onNext(books)
            }
        })
    }
}
