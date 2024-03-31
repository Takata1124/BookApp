//
//  HomeViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/23.
//

import UIKit

class HomeViewController: BaseViewController {

    private var homeViewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel = HomeViewModel()
        
        setupFooterView()
        setupNotification()
    }
    
    func setupFooterView() {
        let footterView = FootterView(viewController: self, frame: .zero)
        self.view.addSubview(footterView)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.buttonTapped(sender:)), name: Notification.Name("SearchViewName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUpMyPageView(sender:)), name: Notification.Name("MyPageViewName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUpChartView(sender:)), name: Notification.Name("ChartViewName"), object: nil)
    }
    
    @objc func buttonTapped(sender : Any) {
        Router(viewController: self, nameVC: "SearchView", model: nil).goNextView()
    }
    
    @objc func setUpMyPageView(sender : Any) {
        let myPageViewMode: MyPageViewModel = MyPageViewModel()
        Router(viewController: self, nameVC: "MyPageView", model: myPageViewMode).goNextView()
    }
    
    @objc func setUpChartView(sender : Any) {
        let chartViewModel: ChartViewModel = ChartViewModel()
        Router(viewController: self, nameVC: "ChartView", model: chartViewModel).goNextView()
    }
    
    @IBAction func settingAction(_ sender: Any) {
        Router(viewController: self, nameVC: "SettingSettingView", model: nil).goNextView()
    }
    
    @IBAction func didRankingTapped(_ sender: Any) {
        let rankingViewModel: RankingViewModel = RankingViewModel()
        Router(viewController: self, nameVC: "RankingView", model: rankingViewModel).goNextView()
    }
}
