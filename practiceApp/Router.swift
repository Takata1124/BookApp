//
//  Router.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/24.
//

import Foundation
import UIKit

class Router {
    private var vc: BaseViewController!
    private var nameVC: String!
    
    init(viewController: BaseViewController, nameVC: String?, model: BaseViewModel?) {
        self.vc = viewController
        if let nameVC = nameVC {
            self.nameVC = nameVC
        }
        if let model = model {
            self.vc.model = model
        }
    }
}

extension Router {
    func goNextView() {
        let storyboard = UIStoryboard(name: nameVC, bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: nameVC) as? BaseViewController
        nextVC?.modalPresentationStyle = .fullScreen
        if let model = self.vc.model {
            nextVC?.model = model
        }
        vc.present(nextVC ?? BaseViewController(), animated: false)
    }
    
    func goBackView() {
        vc.dismiss(animated: false)
    }
    
    func goAfterBackView() {
        vc.presentingViewController?.presentingViewController?.dismiss(animated: false)
    }
}
