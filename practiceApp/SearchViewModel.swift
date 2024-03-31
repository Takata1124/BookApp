//
//  SearchViewModel.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/26.
//

import Foundation
import Combine

class SearchViewModel: NSObject {
    
    static let shared = SearchViewModel()
    
    static func searchBooks(text: String, items: [Item]) async throws -> [Item] {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    var items: [Item] = items
                    let page = items.count / 30 + 1
                    let rakuteObject = RakuteObject(keyword: text, hits: 30, page: page)
                    let response = try await APIClient.httpRequest(decodableType: Rakuten.self, urlString: EnumObjectData.rakuten.getUrl( rakuteObject: rakuteObject, libraryObject: nil), method: .get, parameters: [:])
                    guard let response = response as? Rakuten else { return }
                    response.Items.forEach { item in
                        let title = item.Item.title
                        let author = item.Item.author
                        let itemCaption = item.Item.itemCaption
                        let isbn = item.Item.isbn
                        let salesDate = item.Item.salesDate
                        let largeImageUrl = item.Item.largeImageUrl
                        items.append(Item(title: title, author: author, isbn: isbn, salesDate: salesDate, itemCaption: itemCaption, largeImageUrl: largeImageUrl))
                    }
                    continuation.resume(returning: items)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
