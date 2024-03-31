//
//  DataType.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/24.
//

import Foundation

struct Rakuten: Decodable {
    let Items: [Items]
}

struct Items: Decodable {
    let Item: Item
}

struct Item: Decodable, Hashable {
    let title: String
    let author: String
    let isbn: String
    let salesDate: String
    let itemCaption: String
    let largeImageUrl: String
}

struct Location: Decodable {
    let short: String
    let post: String
    let tel: String
    let pref: String
    let city: String
    let address: String
    let geocode: String
    let distance: Double
    let systemid: String
    let url_pc: String
}

struct RakuteObject {
    var keyword: String
    var hits: Int
    var page: Int
}

struct LibraryObject {
    var isbn: String
    var systemId: String
}

enum EnumObjectData: String {
    case rakuten = "rakuten"
    case library = "library"
    
    func getUrl(rakuteObject: RakuteObject?, libraryObject: LibraryObject?) -> String {
        switch self {
        case .rakuten:
            let page = String(rakuteObject!.page)
            let hits = String(rakuteObject!.hits)
            let encodeKeyword: String = (rakuteObject?.keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
            let url = "https://app.rakuten.co.jp/services/api/BooksTotal/Search/20170404?format=json&keyword=\(encodeKeyword)&booksGenreId=000&hits=\(hits)&page=\(page)&applicationId=\(Apikey.rakutenapikey)"
            return url
        case .library:
            let library_api_key = Apikey.libraryApikey
            let url = "https://api.calil.jp/check?appkey=\(library_api_key)&isbn=\(String(describing: libraryObject?.isbn))&systemid=\(String(describing: libraryObject?.systemId))&callback=no&format=json"
            return url
        }
    }
}

struct IsbnData: Decodable {
    let summary: Summary
    let hanmoto: Hanmoto
    let onix: Onix
}

struct Hanmoto: Decodable {
    let datecreated: String
}

struct Summary: Decodable {
    let isbn: String
    let title: String
    let pubdate: String
    let cover: String
    let author: String
}

struct Onix: Decodable {
    let CollateralDetail: CollateralDetail
}

struct CollateralDetail: Decodable {
    let TextContent: [TextContent]
}

struct TextContent: Decodable {
    let Text: String
}
