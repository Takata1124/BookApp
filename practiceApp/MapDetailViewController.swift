//
//  MapDetailViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/23.
//

import UIKit
import Combine

class MapDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var xButton: UIButton!
    
    public var buttonPressedSubject = PassthroughSubject<Void, Never>()
    
    var statusDics: [statusDic] = [] {
        didSet {
            var initialDic: [statusDic] = []
            var keys: [String] = []
            _ = statusDics.map({ statusDic in
                if !keys.contains(where: { key in
                    key == statusDic.key
                }) {
                    keys.append(statusDic.key)
                    initialDic.append(statusDic)
                }
            })
            statusDics = initialDic
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusDics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = statusDics[indexPath.row].key + "：" + statusDics[indexPath.row].value
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  40
    }
    
    @IBAction func xAction(_ sender: Any) {
        buttonPressedSubject.send()
    }
}
