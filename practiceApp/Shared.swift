//
//  Shared.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/31.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Shared {
    
    static let instance = Shared()
    
    var uid: String {
        get {
            guard let uid = Auth.auth().currentUser?.uid else { return "" }
            return uid
        }
    }
    
    init() {
        
    }
}
