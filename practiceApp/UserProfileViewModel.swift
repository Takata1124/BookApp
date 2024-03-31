//
//  UserProfileViewModel.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/31.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

enum ConversionError: Error {
    case failed
    case unexpected(String)
}

class UserProfileViewModel: BaseViewModel {
    
    let subject = PublishSubject<UIImage>()
    let usernameSubject = PublishSubject<String>()
    let dateSubject = PublishSubject<String>()
    
    func saveUserProfileImage(imageData: Data) async throws -> Void {
        return try await withCheckedThrowingContinuation { continuation in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let storageRef = Storage.storage().reference().child("profile_image").child(uid)
            storageRef.putData(imageData, metadata: nil) { _, err in
                if let err = err {
                    continuation.resume(throwing: err)
                }
                continuation.resume(returning: Void())
            }
        }
    }
    
    func getUserProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_image").child(uid)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            }
            if let image = UIImage(data: data!) {
                self.subject.onNext(image)
            }
        }
    }
    
    func getUserProfileInfo() async throws -> Void  {
        do {
            let uid: String = Shared.instance.uid
            let document = try await Firestore.firestore().collection("users").document(uid).getDocument()
            if let data = document.data() {
                let username = data["username"] as! String
                let timestamp = data["createdAt"] as! Timestamp
                let timeStampDateValue = timestamp.dateValue()
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ja_JP")
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
                let dateString = formatter.string(from: timeStampDateValue)
                usernameSubject.onNext(username)
                dateSubject.onNext(dateString)
            }
            return Void()
        } catch {
            throw ConversionError.unexpected("error")
        }
    }
    
    func saveUserProfileInfo(username: String) async throws -> Void {
        do {
            let uid: String = Shared.instance.uid
            let storeData: [String: Any] = ["username": username,
                                            "createdAt": Timestamp(),
                                            "userUid": uid]
            let ref: Void = try await Firestore.firestore().collection("users").document(uid).setData(storeData)
            return ref
        } catch {
            throw ConversionError.unexpected("error")
        }
    }
}
