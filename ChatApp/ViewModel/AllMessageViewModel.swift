//
//  AllMessageViewModel.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 21/10/23.
//

import Foundation
import SwiftUI
@MainActor
class AllMessageViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var photoURL: String?
    @Published var recentMessage: [RecentMessageModel] = []
    
    
    func getUserPhotoUrl(userId: String) async -> String  {
       
            do {
                let userModel = try await UserManager.shared.getUser(userId: userId)
                return userModel.photoUrl ?? ""
            } catch let error {
                print("Error fetching user data: \(error)")
                return ""
            }
        
    }
    

    
    func fetchRecentMessages(fromId: String) {
        DispatchQueue.main.async {
            
            RecentMessageManager.shared.fetchAllRecentMessages(fromId: fromId) { recentMessages in
                self.recentMessage = []
                self.recentMessage = recentMessages
               
            }
        }
    }
    
    func downloadImage(urlString: String) async -> UIImage?{
        do {
            return try await ImageDownloader.shared.downloadImage(urlString: urlString)
        } catch let error {
            print("Error in downloading Image: \(error.localizedDescription)")
        }
        return nil
    }
    
    
//    func getProfilePhotoFromCache(){
////        guard let url = self.photoURL else {return nil}
//        self.profileImage = CacheManager.shared.getProfileImageFromCache()
////        if existingImageUrl == url {
////            return await downloadImage(urlString: url)
////        } else {
////            return image
////        }
//        
//    }
}

