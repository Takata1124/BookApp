//
//  MyPageViewModel.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/09.
//

import Foundation
import Combine

class MyPageViewModel: BaseViewModel {

    lazy var subject = PassthroughSubject<[Item], Error>()
    private var cancellables = Set<AnyCancellable>()
    
    var itemsCount: Int = 0
    var items: [Item] = []
    
    override init() {
        super.init()
        
        setUpCombine()
        setUpSqlite()
    }
    
    func setUpCombine() {
        subject.sink(receiveCompletion: {
            print ("completion:\($0)")
        },
        receiveValue: {
            self.items = $0
        })
        .store(in: &cancellables)
    }
    
    func sendCombine() {
        subject.send([])
    }
    
    func setUpSqlite() {
        SqliteManager.shared.selectItem { items, err  in
            if err != nil {
                return
            }
            if let items = items {
                self.subject.send(items)
            }
        }
    }
}
