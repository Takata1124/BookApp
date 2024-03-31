//
//  UserProfileViewController.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/31.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UserProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var userProfileViewModel: UserProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileViewModel = model as? UserProfileViewModel
        
        setupConnect()
        setupView()
        getUserProfileInfo()
        getUserProfileImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupIndicator()
    }
    
    private func setupView() {
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.cornerRadius = 100
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
    }
    
    private func setupConnect() {
        _ = userProfileViewModel?.subject.subscribe({ image in
            if let uiImage = image.element {
                self.profileImageView.image = uiImage
                self.dismissIndicator()
            }
        })
        
        _ = userProfileViewModel?.usernameSubject.subscribe({ username in
            if let username = username.element {
                DispatchQueue.main.sync {
                    self.usernameTextField.text = username
                }
            }
        })
        
        _ = userProfileViewModel?.dateSubject.subscribe({ date in
            if let date = date.element {
                DispatchQueue.main.sync {
                    self.dateLabel.text = date
                }
            }
        })
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        present(imagePickerController,animated: true,completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let setImage = (info[.originalImage] as! UIImage)
        profileImageView.image = setImage
        picker.dismiss(animated: true)
    }
    
    private func getUserProfileImage() {
        userProfileViewModel?.getUserProfileImage()
    }
    
    private func getUserProfileInfo() {
        Task {
            _ = try await userProfileViewModel?.getUserProfileInfo()
        }
    }
    
    private func saveUserProfileImage() async {
        do {
            guard let imageData = profileImageView.image?.jpegData(compressionQuality: 0.5) else { return }
            _ = try await userProfileViewModel?.saveUserProfileImage(imageData: imageData)
        } catch {
            print(error)
        }
    }
  
    private func saveUserProfileInfo() async {
        do {
            _ = try await userProfileViewModel?.saveUserProfileInfo(username: "aaa")
        } catch {
            print(error)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        setupIndicator()
        Task {
            _ = await saveUserProfileImage()
            _ = await saveUserProfileInfo()
        }
        dismissIndicator()
    }
    
    @IBAction func goBackView(_ sender: Any) {
        goBackView()
    }
}
