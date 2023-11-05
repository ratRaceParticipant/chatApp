//
//  AuthenticationController.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 08/10/23.
//

import Foundation
import FirebaseAuth
import Firebase


class AuthenticationController: ObservableObject {
    
    static let shared = AuthenticationController()
    private var handler:  AuthStateDidChangeListenerHandle?
    private var currentUserId: String = ""
    init(){
        self.handler = Auth.auth().addStateDidChangeListener(  { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        })
    }
    
    
    func getCurrentUser() -> UserModel? {
        let currentUser = Auth.auth().currentUser
        
        guard let user = currentUser else { return nil }
        let userModel = UserModel(user: user)
        
        return userModel
    }
    
    
    func createUser(email: String, password: String) async throws -> UserModel {
        let auth = try await Auth.auth().createUser(withEmail: email, password: password)
        let userModel = UserModel(user: auth.user)
        
        UserManager.shared.writeToUser(user: userModel)
        return userModel
    }
    
    func signIn(email: String, password: String) async throws -> UserModel{
        
        let auth = try await Auth.auth().signIn(withEmail: email, password: password)
        
        let userModel = UserModel(user: auth.user)
        
//        UserManager.shared.writeToUser(user: userModel)
        return userModel
    }
    
    func logOut() throws {
       try Auth.auth().signOut()
    }
    
}
