//
//  BookDetailViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/26.
//

import UIKit

class BookDetailViewController: BaseViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var item: Item?
    
    var bookDetailViewModel: BookDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookDetailViewModel = model as? BookDetailViewModel
        
        if let favoriteCount = bookDetailViewModel?.favoriteCount {
            let button = UIButton(type: .system)
            button.semanticContentAttribute = .forceRightToLeft
            button.addTarget(self,
                             action: #selector(self.buttonTapped(sender:)),
                             for: .touchUpInside)
            if favoriteCount > 0 {
                button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                let searchBarButtonItem = UIBarButtonItem(customView: button)
                self.navigationBar.topItem?.rightBarButtonItem = searchBarButtonItem
            } else {
                button.setImage(UIImage(systemName: "star"), for: .normal)
                let searchBarButtonItem = UIBarButtonItem(customView: button)
                self.navigationBar.topItem?.rightBarButtonItem = searchBarButtonItem
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout(item: bookDetailViewModel?.item)
        setupImage(item: bookDetailViewModel?.item)
    }
    
    private func setupLayout(item: Item?) {
        self.item = item
        titleLabel.text = item?.title
    }
    
    private func setupImage(item: Item?) {
        guard let item = item else { return }
        Task {
            do {
                let image = try await APIClient.alamofireImageRequest(url: item.largeImageUrl)
                bookImageView.image = image
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        Router(viewController: self, nameVC: nil, model: nil).goBackView()
    }
    
    @IBAction func goMapView(_ sender: Any) {
        guard let item = item else { return }
        let mapViewModel: MapViewMode = MapViewMode(item: item)
        Router(viewController: self, nameVC: "MapView", model: mapViewModel).goNextView()
    }
    
    @objc func buttonTapped(sender : Any) {
        if let item = self.item {
            SqliteManager.shared.insertItem(item: item)
        }
    }
    
    @IBAction func deleteFavorite(_ sender: Any) {
        Router(viewController: self, nameVC: nil, model: nil).goAfterBackView()
    }
}
