//
//  StorageManager.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 14/10/23.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    var currentUser = AuthenticationController.shared.getCurrentUser()
     
    private let storage = Storage.storage().reference(
        withPath: AuthenticationController.shared.getCurrentUser()?.userId ?? UUID().uuidString
    )
    
    func saveImage(data: Data) async throws -> (path: String, downloadUrl: String) {
        let returnedStorageData = try await storage.putDataAsync(data)
        
        guard let returnedPath = returnedStorageData.path, let _ = returnedStorageData.name else {
            throw URLError(.badServerResponse)
            
        }
        let downloadURL = try await storage.downloadURL()
        currentUser?.photoUrl = downloadURL.absoluteString
        guard let userData = currentUser else {
            throw URLError(.cannotCreateFile)
        }
        try UserManager.shared.updateUserData(DBUser: userData)
        return (returnedPath, downloadURL.absoluteString)
    }
}
