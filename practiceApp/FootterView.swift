//
//  FootterView.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/24.
//

import Foundation
import UIKit

class FootterView: UIView {
    
    var view: UIView!
    var viewController: UIViewController!
    
    init(viewController: UIViewController, frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .systemGray
        if let view = viewController.view {
            self.view = view
            self.viewController = viewController
        }
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        DispatchQueue.main.async {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -125).isActive = true
            self.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
            self.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
            self.heightAnchor.constraint(equalToConstant: 125.0).isActive = true
        }
        
        let leftButton = UIButton()
        leftButton.backgroundColor = .green
        leftButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        leftButton.setTitleColor(.label, for: .normal)
        leftButton.addTarget(self,
                         action: #selector(self.buttonTapped(sender:)),
                         for: .touchUpInside)
        
        let leftCenterButton = UIButton()
        leftCenterButton.backgroundColor = .green
        leftCenterButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
        leftCenterButton.setTitleColor(.label, for: .normal)
        leftCenterButton.addTarget(self,
                         action: #selector(self.setUpMyPageView(sender:)),
                         for: .touchUpInside)
        
        let rightCenterButton = UIButton()
        rightCenterButton.backgroundColor = .green
        rightCenterButton.setImage(UIImage(systemName: "message"), for: .normal)
        rightCenterButton.setTitleColor(.label, for: .normal)
        rightCenterButton.addTarget(self,
                         action: #selector(self.buttonTapped(sender:)),
                         for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.backgroundColor = .green
        rightButton.setImage(UIImage(systemName: "chart.bar"), for: .normal)
        rightButton.setTitleColor(.label, for: .normal)
        rightButton.addTarget(self,
                         action: #selector(self.setUpChartView(sender:)),
                         for: .touchUpInside)
        
        let uiStackView = UIStackView()
        uiStackView.axis = .horizontal
        uiStackView.spacing = 15
        uiStackView.alignment = .fill
        uiStackView.distribution = .fillEqually
        self.addSubview(uiStackView)
        uiStackView.translatesAutoresizingMaskIntoConstraints = false
        
        uiStackView.addArrangedSubview(leftButton)
        uiStackView.addArrangedSubview(leftCenterButton)
        uiStackView.addArrangedSubview(rightCenterButton)
        uiStackView.addArrangedSubview(rightButton)
        
        DispatchQueue.main.async {
            NSLayoutConstraint.activate([
                uiStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25),
                uiStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25),
                uiStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
                uiStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25)
            ])
        }
    }
    
    @objc func buttonTapped(sender : Any) {
        NotificationCenter.default.post(name: Notification.Name("SearchViewName"), object: nil)
    }
    
    @objc func setUpMyPageView(sender : Any) {
        NotificationCenter.default.post(name: Notification.Name("MyPageViewName"), object: nil)
    }
    
    @objc func setUpChartView(sender : Any) {
        NotificationCenter.default.post(name: Notification.Name("ChartViewName"), object: nil)
    }
}
