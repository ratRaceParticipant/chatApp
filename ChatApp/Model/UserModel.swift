//
//  UserModel.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 08/10/23.
//

import Foundation
import FirebaseAuth

class UserModel: Codable, Identifiable {
    let userId: String
    let email: String?
    var photoUrl: String?
    
    init(user: User) {
        self.email = user.email
        self.userId = user.uid
        self.photoUrl = user.photoURL?.absoluteString
    }
    
    init(userId: String,email: String, photoUrl: String?) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
    }
}
