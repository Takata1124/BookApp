//
//  ViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/01/04.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func setupNewUser(_ sender: Any) {
        let email = "aaa@gmail.com"
        let password = "aaaaaa"
        Task {
            do {
                let result = try await FirebaseManger.setupFirebaseUser(email: email, password: password)
                print(result)
                goHomeView()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func loginUser(_ sender: Any) {
        let email = "aaa@gmail.com"
        let password = "aaaaaa"
        Task {
            do {
                let authResult = try await FirebaseManger.firebaseSignIn(email: email, password: password)
                print(authResult.user.uid)
                print(authResult.user.email ?? "")
                goHomeView()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func goGestLogin(_ sender: Any) {
        
    }
    
    func goHomeView() {
        let homeStoryboard = UIStoryboard(name: "HomeView", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeView")
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: false)
    }
}

