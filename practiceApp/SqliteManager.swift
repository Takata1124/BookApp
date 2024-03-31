//
//  SqliteManager.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/10.
//

import Foundation
import GRDB
import Combine

class SqliteManager {
    
    let FILE_NAME = "mypage.db"
    let filePath: String?
    var dbQueue: DatabaseQueue?
    
    static var shared = SqliteManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(FILE_NAME).path
    }
    
    func openDB() {
        if let filePath = self.filePath {
            do {
                self.dbQueue = try DatabaseQueue(path: filePath)
            } catch {
                print(error)
            }
        }
    }
    
    func createTable() {
        do {
            try dbQueue?.write({ db in
                try db.execute(sql:
                    """
                    CREATE TABLE IF NOT EXISTS item (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        title TEXT,
                        author TEXT,
                        isbn TEXT,
                        salesdate TEXT,
                        largeImageUrl TEXT
                    )
                    """
                )
            })
        } catch {
            print(error)
        }
    }
    
    func insertItem(item: Item) {
        print(item)
        do {
            try dbQueue?.write({ db in
                try db.execute(
                    sql: "INSERT INTO item (title, author, isbn, salesdate, largeImageUrl) VALUES (?, ?, ?, ?, ?)",
                    arguments: [item.title, item.author, item.isbn, item.salesDate, item.largeImageUrl])
            })
            print("INSERT ITEM")
        } catch {
            print(error)
        }
    }
    
    func selectItem(completion: @escaping ([Item]?, Error?) -> Void) {
        var itemArr: [Item] = []
        do {
            if let items = try dbQueue?.read({ db in
                try Row.fetchAll(db, sql: "SELECT * FROM item")
            }) {
                _ = items.map { item in
                    let title: String = item["title"] ?? ""
                    let author: String = item["author"] ?? ""
                    let isbn: String = item["isbn"] ?? ""
                    let salesdate: String = item["salesdate"] ?? ""
                    let largeImageUrl: String = item["largeImageUrl"] ?? ""
                    itemArr.append(Item(title: title, author: author, isbn: isbn, salesDate: salesdate, itemCaption: "", largeImageUrl: largeImageUrl))
                }
            }
            completion(itemArr, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func deleteItem(item: Item) -> Future<Void, Error> {
        return Future() { [self] promise in
            do {
                try dbQueue?.write({ db in
                    try db.execute(
                        sql: "DELETE FROM item WHERE isbn=?",
                        arguments: [item.isbn])
                })
                print("DELETE ITEM")
                promise(Result.success(()))
            } catch {
                print(error)
                promise(Result.failure(() as! Error))
            }
        }
    }
    
    func isExistItem(item: Item) -> Future<Int, Error> {
        return Future() { [self] promise in
            do {
                let count = try dbQueue?.read({ db in
                    try Row.fetchOne(db, sql: "SELECT COUNT(*) FROM item WHERE isbn=?", arguments: [item.isbn])
                })
                guard let countInt = count?.first else { return promise(Result.failure(() as! Error))}
                guard let int = Int(countInt.1.description) else { return promise(Result.failure(() as! Error))}
                promise(.success(int))
            } catch {
                print(error)
                promise(Result.failure(() as! Error))
            }
        }
    }
}

