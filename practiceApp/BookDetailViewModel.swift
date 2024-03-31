//
//  BookDetailViewModel.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/28.
//

import Foundation

class BookDetailViewModel: BaseViewModel {
    
    var item: Item?
    var favoriteCount: Int = 0
    
    init(item: Item) {
        super.init()
        self.item = item
        
        _ = SqliteManager.shared.isExistItem(item: item)
            .sink { error in
                print(error)
            } receiveValue: { int in
                self.favoriteCount = int
            }
    }
}
