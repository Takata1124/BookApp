//
//  MyPageViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/03.
//

import UIKit
import Combine

class MyPageViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var cancellables = Set<AnyCancellable>()
    private var myPageViewModel: MyPageViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPageViewModel = model as? MyPageViewModel
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
        
        setUpCombine()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.backgroundColor = UIColor.systemGray4
    }
    
    func setUpCombine() {
        _ = myPageViewModel?.subject.sink(receiveCompletion: {
            print ("completion:\($0)")
        },
        receiveValue: {_ in
            self.collectionView.reloadData()
        })
        .store(in: &cancellables)
    }
    
    @IBAction func goBackView(_ sender: Any) {
        Router(viewController: self, nameVC: nil, model: nil).goBackView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = myPageViewModel?.items.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        guard let postCell = customCell as? CollectionViewCell else { return customCell }
        if let item = myPageViewModel?.items[indexPath.row] {
            postCell.item = item
        }
        return postCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = myPageViewModel?.items[indexPath.row] else { return }
        let bookDetailViewModel: BookDetailViewModel = BookDetailViewModel(item: item)
        Router(viewController: self, nameVC: "BookDetailView", model: bookDetailViewModel).goNextView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat = self.view.bounds.width/3 - 10
        return CGSize(width: cellSize, height: cellSize)
    }
}
