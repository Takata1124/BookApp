//
//  SearchViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/24.
//

import UIKit
import Combine

class SearchViewController: BaseViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchViewModel: SearchViewModel?
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var page: Int = 0
    var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewModel = SearchViewModel.shared
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        searchViewModel = nil
    }
    
    func setupFooterView() {
        let footterView = FootterView(viewController: self, frame: .zero)
        self.view.addSubview(footterView)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        guard let searchText = searchBar.text else { return }
        if searchText == "" { return }
        Task {
            do {
                appDelegate.startLoaging()
                items = try await SearchViewModel.searchBooks(text: searchText, items: items)
                appDelegate.stopLoading()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        if items.count > 0 {
            cell.item = items[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item: Item = items[indexPath.row]
        let bookDetailViewModel: BookDetailViewModel = BookDetailViewModel(item: item)
        Router(viewController: self, nameVC: "BookDetailView", model: bookDetailViewModel).goNextView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  100
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            guard let searchText = searchBar.text else { return }
            if searchText == "" { return }
            Task {
                do {
                    appDelegate.startLoaging()
                    items = try await SearchViewModel.searchBooks(text: searchText, items: items)
                    appDelegate.stopLoading()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        Router(viewController: self, nameVC: nil, model: nil).goBackView()
    }
    
    @IBAction func favorite(_ sender: Any) {
        let barcodeViewModel: BarcodeViewModel = BarcodeViewModel()
        Router(viewController: self, nameVC: "BarcodeView", model: barcodeViewModel).goNextView()
    }
}
