//
//  SettingViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/10.
//

import UIKit

enum Settings: String {
    case version = "アプリバージョン"
    case explain = "取扱説明"
    case userPfofile = "プロフィール"
    case withdraw = "退会"
    case logout = "ログアウト"
}

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let settings: [Settings] = [.version, .explain, .userPfofile, .withdraw, .logout]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func goBackView(_ sender: Any) {
        Router(viewController: self, nameVC: nil, model: nil).goBackView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let setting: String = settings[indexPath.row].rawValue
        cell.textLabel!.text = setting
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let setting: String = settings[indexPath.row].rawValue
        if setting ==  Settings.userPfofile.rawValue {
            let userProfileViewModel: UserProfileViewModel = UserProfileViewModel()
            Router(viewController: self, nameVC: "UserProfileView", model: userProfileViewModel).goNextView()
        }
    }
}
