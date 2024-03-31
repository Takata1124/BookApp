//
//  BaseViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/28.
//

import UIKit

class BaseViewController: UIViewController {
    
    var model: BaseViewModel? = nil
    let loadingView = UIView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func goBackView() {
        Router(viewController: self, nameVC: nil, model: nil).goBackView()
    }
    
    func setupIndicator() {
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = loadingView.center
        activityIndicator.color = UIColor.white
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        label.center = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 90)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "ただいま処理中です..."
        loadingView.addSubview(label)
        let window = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows.filter { $0.isKeyWindow }.first
        window?.addSubview(loadingView)
    }
    
    func dismissIndicator() {
        loadingView.removeFromSuperview()
    }
}
