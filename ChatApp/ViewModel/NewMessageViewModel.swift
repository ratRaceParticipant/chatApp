//
//  NewMessageViewModel.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 21/10/23.
//

import Foundation
@MainActor
class NewMessageViewModel: ObservableObject {
    @Published var allUsers: [UserModel] = []
    @Published var userModel: [UserModel] = []
    @Published var anyUserFound: Bool = false
    
    func getAllUsers() async {
        
        do{
            allUsers = try await UserManager.shared.getUsersWithEmail()
           
            
        } catch let error {
            print("Error fetching all users \(error)")
        }
    }
    func searchUser(searchText: String) {
        userModel = []
        for document in allUsers {
            if let email = document.email, email.localizedCaseInsensitiveContains(searchText) {
                anyUserFound = true
                userModel.append(document)
            }
  
        }
        if userModel.isEmpty {
            anyUserFound = false
        }
    }
}
