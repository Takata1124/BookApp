//
//  BarcodeViewModel.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/21.
//

import Foundation

class BarcodeViewModel: BaseViewModel {
    
    override init() {}
    
    func getIsbnBook(isbn: String) async throws -> Item  {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                let url: String = "https://api.openbd.jp/v1/get?isbn=\(isbn)"
                do {
                    let response: [IsbnData] = try await APIClient.httpRequest(decodableType: [IsbnData].self, urlString: url, method: .get, parameters: [:]) as! [IsbnData]
                    _ = response.map { data in
                        let isbn = data.summary.isbn
                        let title = data.summary.title
                        let pubdata = data.summary.pubdate
                        let author = data.summary.author
                        let item = Item(title: title, author: author, isbn: isbn, salesDate: pubdata, itemCaption: "", largeImageUrl: "")
                        continuation.resume(returning: item)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
