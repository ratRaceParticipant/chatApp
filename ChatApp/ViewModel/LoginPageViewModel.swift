//
//  LoginPageViewModel.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 08/10/23.
//

import Foundation
import Firebase
import SwiftUI
import PhotosUI


@MainActor
class LoginPageViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userProfilePhoto: PhotosPickerItem? = nil
    @Published var errorMessage: String = ""
    func actionHandler(email: String, password: String, isCreateNewAccount: Bool, userProfilePhoto: PhotosPickerItem?) async -> UserModel? {
        errorMessage = ""
        guard !email.isEmpty,
              !password.isEmpty,
              password.count > 5
        else {
            return nil
        }
        if isCreateNewAccount {
            do {
                let userData =  try await AuthenticationController.shared.createUser(email: email,password: password)
                guard let image = userProfilePhoto else {
                    return userData
                }
                Task {
                   await uploadProfilePhoto(item: image)
                    
                }
                return userData
            } catch let error {
                errorMessage = "Error in creating account."
                print("Error creating user \(error)")
            }
        } else {
            do {
              return try await AuthenticationController.shared.signIn(email: email, password: password)
            } catch let error {
                errorMessage = "Error in signing in."
                print("Error in signing in user \(error)")
            }
        }
        return nil
              
    }
   
    func uploadProfilePhoto(item: PhotosPickerItem) async {
        do {
            let data = try await item.loadTransferable(type: Data.self)
            guard let imageData = data else {return}
            Task {
                let (path, downloadUrl) = try await StorageManager.shared.saveImage(data: imageData)
 
                
                
                print("Success in uploading image")
                print("Path: \(path)")
                print("Download Url: \(downloadUrl)")
                
            }
        } catch let error {
            print("Error in uploading pfp: \(error)")
        }
    }
}
