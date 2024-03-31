//
//  RankingViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/26.
//

import UIKit
import RxSwift
import RxCocoa

class RankingViewController: BaseViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!

    var rankingViewModel: RankingViewModel?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        rankingViewModel = model as? RankingViewModel
        subscribeFunc()
    }
    
    private func subscribeFunc() {
        _ = rankingViewModel?.subject.subscribe(onNext: { books in
            print(books.title)
        }, onError: {
            print("onError: ", $0.localizedDescription)
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        })
    }
    
    @IBAction func tappedButton(_ sender: Any) {
        rankingViewModel?.setupUserName()
    }
    
    @IBAction func goBackView(_ sender: Any) {
        goBackView()
    }
}
