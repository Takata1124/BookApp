//
//  BooksData.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/31.
//

import Foundation

struct BooksData {
    var title: String = ""
    var author: String = ""
    var isbn: String = ""
    var largeImageUrl: String = ""
    var uid: String = ""
    var salesDate: String = ""
    
    init(dic: [String: Any]) {
        self.title = dic["title"] as? String ?? ""
        self.author = dic["author"] as? String ?? ""
        self.isbn = dic["isbn"] as? String ?? ""
        self.largeImageUrl = dic["largeImageUrl"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.salesDate = dic["salesDate"] as? String ?? ""
    }
}
